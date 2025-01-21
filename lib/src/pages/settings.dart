import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/user.model.dart' as user_model;
import 'package:trancend/src/pages/theme_editor.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/services/background_audio.service.dart';
import 'package:trancend/src/services/firestore.service.dart';
import 'package:trancend/src/services/storage_service.dart';
import 'package:trancend/src/ui/clay/clay_container.dart';
import 'package:trancend/src/ui/clay/clay_radio_button.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier();
});

final backgroundSoundProvider = StateProvider<user_model.BackgroundSound?>((ref) => null);

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier() : super(false) {
    _loadDarkMode();
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('darkMode') ?? false;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', !state);
    state = !state;
  }
}

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsPage> {
  final _backgroundAudioService = locator<BackgroundAudioService>();
  final _firestoreService = locator<FirestoreService>();
  bool _isPlaying = false;

  // Add controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  String? _errorMessage;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _fieldErrors = {};
  String? _serverError;

  Future<void> _stopAudio() async {
    if (_isPlaying) {
      await _backgroundAudioService.stop();
      setState(() => _isPlaying = false);
    }
  }

  @override
  void dispose() {
    _stopAudio();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _showAuthSheet(BuildContext context, {bool isSignUp = false}) {
    // Clear form state when showing sheet
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _fieldErrors.clear();
      _serverError = null;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: GlassContainer(
          backgroundColor: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return isSignUp ? _buildSignUpContent(context, setModalState) : _buildLoginContent(context, setModalState);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref, user_model.User user) {
    return ClayContainer(
      color: Theme.of(context).colorScheme.surface,
      parentColor: Theme.of(context).colorScheme.surface,
      borderRadius: 12,
      width: double.infinity,
      height: 100,
      depth: 20,
      spread: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white24,
              backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
              child: user.photoUrl.isEmpty
                  ? const Icon(Remix.user_line, color: Colors.white70, size: 30)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AutoSizeText(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
    
    // Force app reload by invalidating all providers
    ref.invalidate(userProvider);
    ref.invalidate(backgroundSoundProvider);
    
    // Rebuild the entire app
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/', 
        (route) => false
      );
    }
  }

  Future<void> _handleAuthSuccess(BuildContext context) async {
    // Force app reload by invalidating all providers
    ref.invalidate(userProvider);
    ref.invalidate(backgroundSoundProvider);
    
    // Rebuild the entire app
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/', 
        (route) => false
      );
    }
  }

  Widget _buildLoginContent(BuildContext context, StateSetter setModalState) {
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
                setModalState(() {
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
                    color: _fieldErrors['email'] != null ? Colors.white : Colors.transparent,
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
                setModalState(() {
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
                    color: _fieldErrors['password'] != null ? Colors.white : Colors.transparent,
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
                setModalState(() {
                  _fieldErrors.clear();
                  _serverError = null;
                });
                
                bool isValid = _validateEmail(_emailController.text) &
                             _validatePassword(_passwordController.text);
                
                if (!isValid) {
                  setModalState(() {});
                  return;
                }

                final authService = ref.read(authServiceProvider);
                final result = await authService.loginWithEmail(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                
                if (result.success) {
                  Navigator.pop(context);
                  await _handleAuthSuccess(context);
                } else {
                  setModalState(() {
                    _serverError = result.errorMessage;
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
                    if (result.success) {
                      Navigator.pop(context);
                      await _handleAuthSuccess(context);
                    } else {
                      setModalState(() {
                        _serverError = result.errorMessage;
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
                      Navigator.pop(context);
                      await _handleAuthSuccess(context);
                    } else {
                      setModalState(() {
                        _serverError = result.errorMessage;
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
                      Navigator.pop(context);
                      await _handleAuthSuccess(context);
                    } else {
                      setModalState(() {
                        _serverError = result.errorMessage;
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
                _showAuthSheet(context, isSignUp: true);
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

  Widget _buildSignUpContent(BuildContext context, StateSetter setModalState) {
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
                setModalState(() {
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
                    color: _fieldErrors['name'] != null ? Colors.white : Colors.transparent,
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
                setModalState(() {
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
                    color: _fieldErrors['email'] != null ? Colors.white : Colors.transparent,
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
                setModalState(() {
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
                    color: _fieldErrors['password'] != null ? Colors.white : Colors.transparent,
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
                setModalState(() {
                  _fieldErrors.clear();
                  _serverError = null;
                });
                
                bool isValid = _validateName(_nameController.text) &
                             _validateEmail(_emailController.text) &
                             _validatePassword(_passwordController.text);
                
                if (!isValid) {
                  setModalState(() {});
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
                  Navigator.pop(context);
                  await _handleAuthSuccess(context);
                } else {
                  setModalState(() {
                    _serverError = result.errorMessage;
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
                  onPressed: () {
                    // TODO: Implement Google signup
                  },
                ),
                _socialLoginButton(
                  icon: Remix.apple_fill,
                  onPressed: () {
                    // TODO: Implement Apple signup
                  },
                ),
                _socialLoginButton(
                  icon: Remix.facebook_fill,
                  onPressed: () {
                    // TODO: Implement Facebook signup
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showAuthSheet(context);
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
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(darkModeProvider);
    final userAsync = ref.watch(userProvider);
    final selectedSound = ref.watch(backgroundSoundProvider) ?? userAsync.value?.backgroundSound;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: theme.textTheme.headlineSmall),
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Remix.lock_line,
                    size: 64,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sign in Required',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Please sign in to access and customize your settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ClayContainer(
                    color: theme.colorScheme.surfaceTint,
                    parentColor: theme.colorScheme.surfaceTint,
                    borderRadius: 12,
                    curveType: CurveType.none,
                    depth: 8,
                    spread: 8,
                    width: 300,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showAuthSheet(context, isSignUp: true),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => _showAuthSheet(context),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white70),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(context, ref, user),
                  const SizedBox(height: 24),
                  ClayContainer(
                    color: theme.colorScheme.surface,
                    parentColor: theme.colorScheme.surface,
                    borderRadius: 12,
                    width: double.infinity,
                    height: 100,
                    depth: 20,
                    spread: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dark Mode',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              ref.read(darkModeProvider.notifier).toggle();
                            },
                            activeColor: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (kIsWeb) ...[
                    const SizedBox(height: 16),
                    ClayContainer(
                      color: theme.colorScheme.surface,
                      parentColor: theme.colorScheme.surface,
                      borderRadius: 12,
                      width: double.infinity,
                      height: 100,
                      depth: 20,
                      spread: 2,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ThemeEditor(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Theme Editor',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: theme.colorScheme.onSurface,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const Divider(),
                  ClayContainer(
                    color: theme.colorScheme.surface,
                    parentColor: theme.colorScheme.surface,
                    borderRadius: 12,
                    width: double.infinity,
                    height: 100,
                    depth: 20,
                    spread: 2,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isDismissible: true,
                            enableDrag: true,
                            barrierColor: Colors.black54,
                            builder: (context) => BackgroundSoundBottomSheet(
                              isPlaying: _isPlaying,
                              onPlayStateChanged: (isPlaying) {
                                setState(() => _isPlaying = isPlaying);
                              },
                              currentSound: user.backgroundSound,
                              onSoundChanged: (sound) async {
                                await ref.read(userProvider.notifier).updateBackgroundSound(sound);
                              },
                            ),
                          ).then((_) async {
                            await _backgroundAudioService.stop();
                            setState(() => _isPlaying = false);
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Set Default Background Sound',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: theme.colorScheme.onSurface,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ClayContainer(
                    color: theme.colorScheme.surfaceTint,
                    parentColor: theme.colorScheme.surfaceTint,
                    borderRadius: 12,
                    width: double.infinity,
                    height: 60,
                    depth: 10,
                    spread: 2,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _handleLogout(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Remix.logout_box_r_line,
                                color: theme.colorScheme.onErrorContainer,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  color: theme.colorScheme.onErrorContainer,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

class BackgroundSoundBottomSheet extends ConsumerStatefulWidget {
  final bool isPlaying;
  final Function(bool) onPlayStateChanged;
  final user_model.BackgroundSound currentSound;
  final Function(user_model.BackgroundSound) onSoundChanged;

  const BackgroundSoundBottomSheet({
    super.key,
    required this.isPlaying,
    required this.onPlayStateChanged,
    required this.currentSound,
    required this.onSoundChanged,
  });

  @override
  ConsumerState<BackgroundSoundBottomSheet> createState() => _BackgroundSoundBottomSheetState();
}

class _BackgroundSoundBottomSheetState extends ConsumerState<BackgroundSoundBottomSheet> {
  final _backgroundAudioService = locator<BackgroundAudioService>();
  final _cloudStorageService = locator<CloudStorageService>();
  late user_model.BackgroundSound _selectedSound;

  Future<void> _stopAudio() async {
    if (widget.isPlaying) {
      await _backgroundAudioService.stop();
      widget.onPlayStateChanged(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedSound = widget.currentSound;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      onPopInvoked: (_) {
        _stopAudio();
        if (_selectedSound != widget.currentSound) {
          widget.onSoundChanged(_selectedSound);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Background Sound',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: user_model.BackgroundSound.values.length,
                itemBuilder: (context, index) {
                  final sound = user_model.BackgroundSound.values[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ClayRadioButton<user_model.BackgroundSound>(
                      value: sound,
                      groupValue: _selectedSound,
                      onChanged: (value) async {
                        if (value == null) return;
                        
                        // Stop current audio before playing new one
                        await _stopAudio();
                        
                        setState(() => _selectedSound = value);

                        try {
                          final result = await _cloudStorageService.getFile(
                            bucket: "background_loops",
                            fileName: value.path,
                          );

                          if (mounted && result.url != null) {
                            await _backgroundAudioService.play(result.url!);
                            widget.onPlayStateChanged(true);
                          }
                        } catch (e) {
                          if (mounted) {
                            setState(() => _selectedSound = widget.currentSound);
                          }
                          print("error playing audio: $e");
                        }
                      },
                      color: theme.colorScheme.surface,
                      parentColor: theme.colorScheme.surface,
                      depth: 20,
                      spread: 2,
                      size: 24,
                      icon: sound.icon,
                      title: sound.string,
                      titleStyle: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
