import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/analytics.service.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

class GlassSignUp extends ConsumerStatefulWidget {
  final Function() onLoginTap;
  final Function() onAuthSuccess;

  const GlassSignUp({
    Key? key,
    required this.onLoginTap,
    required this.onAuthSuccess,
  }) : super(key: key);

  @override
  ConsumerState<GlassSignUp> createState() => _GlassSignUpState();
}

class _GlassSignUpState extends ConsumerState<GlassSignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final Map<String, String> _fieldErrors = {};
  String? _serverError;
  final _analytics = locator<AnalyticsService>();

  @override
  void initState() {
    super.initState();
    _analytics.setCurrentScreen('signup_screen');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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

  bool _validateName(String value) {
    if (value.isEmpty) {
      _fieldErrors['name'] = 'Name is required';
      return false;
    }
    _fieldErrors.remove('name');
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
              'Create Account',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  _validateName(value);
                  _serverError = null;
                });
              },
              decoration: InputDecoration(
                hintText: 'Full Name',
                prefixIcon: const Icon(Remix.user_line, color: Colors.white70),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _fieldErrors['name'] != null
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
                errorText: _fieldErrors['name'],
                errorStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
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
              text: 'Sign Up',
              onPressed: () async {
                setState(() {
                  _fieldErrors.clear();
                  _serverError = null;
                });

                bool isValid = _validateName(_nameController.text) &
                    _validateEmail(_emailController.text) &
                    _validatePassword(_passwordController.text);

                if (!isValid) {
                  setState(() {});
                  return;
                }

                final authService = ref.read(authServiceProvider);
                final newUser = user_model.User(
                  uid: '',
                  email: _emailController.text,
                  displayName: _nameController.text,
                  photoUrl: '',
                );

                final result = await authService.signUpWithEmail(
                  user: newUser,
                  password: _passwordController.text,
                );

                if (result.success) {
                  await _analytics.logSignUp('email');
                  Navigator.pop(context);
                  widget.onAuthSuccess();
                } else {
                  setState(() {
                    _serverError = result.errorMessage;
                  });
                  await _analytics.logEvent('signup_error', parameters: {
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
              'Or sign up with',
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
                    if (result.success) {
                      await _analytics.logSignUp('google');
                      Navigator.pop(context);
                      widget.onAuthSuccess();
                    } else {
                      setState(() {
                        _serverError = result.errorMessage;
                      });
                      await _analytics.logEvent('signup_error', parameters: {
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
                    if (result.success) {
                      await _analytics.logSignUp('apple');
                      Navigator.pop(context);
                      widget.onAuthSuccess();
                    } else {
                      setState(() {
                        _serverError = result.errorMessage;
                      });
                      await _analytics.logEvent('signup_error', parameters: {
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
                    if (result.success) {
                      await _analytics.logSignUp('facebook');
                      Navigator.pop(context);
                      widget.onAuthSuccess();
                    } else {
                      setState(() {
                        _serverError = result.errorMessage;
                      });
                      await _analytics.logEvent('signup_error', parameters: {
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
                widget.onLoginTap();
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(color: Colors.white70),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Login',
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