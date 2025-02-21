import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/analytics.service.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

class GlassLogin extends ConsumerStatefulWidget {
  final Function() onSignUpTap;
  final Function() onAuthSuccess;

  const GlassLogin({
    super.key,
    required this.onSignUpTap,
    required this.onAuthSuccess,
  });

  @override
  ConsumerState<GlassLogin> createState() => _GlassLoginState();
}

class _GlassLoginState extends ConsumerState<GlassLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Map<String, String> _fieldErrors = {};
  String? _serverError;
  final _analytics = locator<AnalyticsService>();

  @override
  void initState() {
    super.initState();
    _analytics.setCurrentScreen('login_screen');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateEmail(String value) {
    if (value.isEmpty) {
      _fieldErrors['email'] = 'Email is required';
      return false;
    }
    if (!value.contains('@')) {
      _fieldErrors['email'] = 'Please enter a valid email';
      return false;
    }
    _fieldErrors.remove('email');
    return true;
  }

  bool _validatePassword(String value) {
    if (value.isEmpty) {
      _fieldErrors['password'] = 'Password is required';
      return false;
    }
    if (value.length < 6) {
      _fieldErrors['password'] = 'Password must be at least 6 characters';
      return false;
    }
    _fieldErrors.remove('password');
    return true;
  }

  Widget _socialLoginButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GlassContainer(
      backgroundColor: Colors.white12,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              onChanged: (value) {
                setState(() {
                  _validateEmail(value);
                  _serverError = null;
                });
              },
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Remix.mail_line, color: Colors.white70),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _fieldErrors['email'] != null
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
                errorText: _fieldErrors['email'],
                errorStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _validatePassword(value);
                  _serverError = null;
                });
              },
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Remix.lock_line, color: Colors.white70),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _fieldErrors['password'] != null
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
                errorText: _fieldErrors['password'],
                errorStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            if (_serverError != null) ...[
              const SizedBox(height: 16),
              Text(
                _serverError!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            GlassButton(
              text: 'Login',
              onPressed: () async {
                setState(() {
                  _fieldErrors.clear();
                  _serverError = null;
                });

                bool isValid = _validateEmail(_emailController.text) &
                    _validatePassword(_passwordController.text);

                if (!isValid) {
                  setState(() {});
                  return;
                }

                final authService = ref.read(authServiceProvider);
                final result = await authService.loginWithEmail(
                  email: _emailController.text,
                  password: _passwordController.text,
                );

                if (!mounted) return;

                if (result.success) {
                  await _analytics.logLogin('email');
                  if (!mounted) return;
                  Navigator.pop(context);
                  widget.onAuthSuccess();
                } else {
                  if (!mounted) return;
                  setState(() {
                    _serverError = result.errorMessage;
                  });
                  await _analytics.logEvent('login_error', parameters: {
                    'error': result.errorMessage,
                    'method': 'email'
                  });
                }
              },
              glassColor: Colors.white24,
              textColor: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'Or continue with',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _socialLoginButton(
                  icon: Remix.google_fill,
                  onPressed: () async {
                    final authService = ref.read(authServiceProvider);
                    final result = await authService.googleSignIn();
                    if (!mounted) return;
                    if (result.success) {
                      await _analytics.logLogin('google');
                      if (!mounted) return;
                      Navigator.pop(context);
                      widget.onAuthSuccess();
                    } else {
                      if (!mounted) return;
                      setState(() {
                        _serverError = result.errorMessage;
                      });
                      await _analytics.logEvent('login_error', parameters: {
                        'error': result.errorMessage,
                        'method': 'google'
                      });
                    }
                  },
                ),
                _socialLoginButton(
                  icon: Remix.apple_fill,
                  onPressed: () async {
                    final authService = ref.read(authServiceProvider);
                    final result = await authService.appleLogin();
                    if (!mounted) return;
                    if (result.success) {
                      await _analytics.logLogin('apple');
                      if (!mounted) return;
                      Navigator.pop(context);
                      widget.onAuthSuccess();
                    } else {
                      if (!mounted) return;
                      setState(() {
                        _serverError = result.errorMessage;
                      });
                      await _analytics.logEvent('login_error', parameters: {
                        'error': result.errorMessage,
                        'method': 'apple'
                      });
                    }
                  },
                ),
                _socialLoginButton(
                  icon: Remix.facebook_fill,
                  onPressed: () async {
                    final authService = ref.read(authServiceProvider);
                    final result = await authService.facebookLogin();
                    if (!mounted) return;
                    if (result.success) {
                      await _analytics.logLogin('facebook');
                      if (!mounted) return;
                      Navigator.pop(context);
                      widget.onAuthSuccess();
                    } else {
                      if (!mounted) return;
                      setState(() {
                        _serverError = result.errorMessage;
                      });
                      await _analytics.logEvent('login_error', parameters: {
                        'error': result.errorMessage,
                        'method': 'facebook'
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onSignUpTap();
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.white70),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 