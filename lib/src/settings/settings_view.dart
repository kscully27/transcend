import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/providers/auth_provider.dart';
import 'package:trancend/src/ui/glass/glass_container.dart';
import 'package:trancend/src/ui/glass/glass_button.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  void _showAuthSheet(BuildContext context, {bool isSignUp = false}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: GlassContainer(
          backgroundColor: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: isSignUp ? _buildSignUpContent(context) : _buildLoginContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref, dynamic user) {
    return GlassContainer(
      backgroundColor: Colors.white10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Remix.logout_box_r_line, color: Colors.white70),
                  onPressed: () async {
                    final authService = ref.read(authServiceProvider);
                    await authService.signOut();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return Column(
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
          decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: const Icon(Remix.mail_line, color: Colors.white70),
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Remix.lock_line, color: Colors.white70),
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 24),
        GlassButton(
          text: 'Login',
          onPressed: () {
            // TODO: Implement email login
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
              onPressed: () {
                // TODO: Implement Google login
              },
            ),
            _socialLoginButton(
              icon: Remix.apple_fill,
              onPressed: () {
                // TODO: Implement Apple login
              },
            ),
            _socialLoginButton(
              icon: Remix.facebook_fill,
              onPressed: () {
                // TODO: Implement Facebook login
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpContent(BuildContext context) {
    return Column(
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
          decoration: InputDecoration(
            hintText: 'Full Name',
            prefixIcon: const Icon(Remix.user_line, color: Colors.white70),
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: const Icon(Remix.mail_line, color: Colors.white70),
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: const Icon(Remix.lock_line, color: Colors.white70),
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 24),
        GlassButton(
          text: 'Sign Up',
          onPressed: () {
            // TODO: Implement email signup
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                  GlassButton(
                    text: 'Sign In',
                    onPressed: () => _showAuthSheet(context),
                    glassColor: Colors.white24,
                    textColor: Colors.white,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(context, ref, user),
                const SizedBox(height: 24),
                // TODO: Add actual settings content below
                const Center(
                  child: Text(
                    'Settings content goes here',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
