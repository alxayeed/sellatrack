import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_state.dart';
import 'package:sellatrack/features/auth/presentation/providers/auth_providers.dart';

import '../../../../core/common/common.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _initialAuthCheckDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //TODO: implement go router redirect for this check
      _checkInitialAuthStateAndNavigate();
    });
  }

  Future<void> _checkInitialAuthStateAndNavigate() async {
    if (_initialAuthCheckDone || !mounted) return;
    _initialAuthCheckDone = true;

    // final authUserAsync = ref.read(authStateChangesProvider);
    // final authUser = authUserAsync.valueOrNull;

    // Option 2: More robustly, use the AuthNotifier which has detailed state
    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.checkCurrentUser();
    final currentAuthState = ref.read(authNotifierProvider);
    final authUser = currentAuthState.user;

    if (authUser != null) {
      if (authUser.displayName != null && authUser.displayName!.isNotEmpty) {
        if (mounted) context.go(AppRoutePaths.home);
      } else {
        if (mounted) context.go(AppRoutePaths.profileCompletion);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showForgotPasswordDialog() {
    final TextEditingController forgotPasswordEmailController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextField(
            controller: forgotPasswordEmailController,
            decoration: const InputDecoration(labelText: 'Enter your email'),
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Send Link'),
              onPressed: () {
                if (forgotPasswordEmailController.text.trim().isNotEmpty) {
                  if (!RegExp(
                    r'^[^@]+@[^@]+\.[^@]+',
                  ).hasMatch(forgotPasswordEmailController.text.trim())) {
                    AppSnackBar.showError(
                      dialogContext,
                      message: 'Please enter a valid email address.',
                    );
                    return;
                  }
                  // ref.read(authNotifierProvider.notifier).sendPasswordResetEmail(
                  // forgotPasswordEmailController.text.trim()); // TODO: Uncomment when method exists in notifier
                  Navigator.of(dialogContext).pop();
                  AppSnackBar.showInfo(
                    context,
                    message: 'Forgot Password - Coming Soon!',
                  );
                } else {
                  AppSnackBar.showError(
                    dialogContext,
                    message: 'Please enter your email.',
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.read(authNotifierProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<AuthScreenState>(authNotifierProvider, (previous, next) {
      final bool wasLoading =
          previous?.status == AuthStatus.loading &&
          (previous!.isLoadingSignIn || previous.isLoadingSignUp);
      final bool isNowError = next.status == AuthStatus.error;

      if (next.status == AuthStatus.profileIncomplete) {
        if (mounted) context.go(AppRoutePaths.profileCompletion);
      } else if (next.status == AuthStatus.authenticated) {
        if (mounted) context.go(AppRoutePaths.home);
      }

      if (next.errorMessage != null &&
          next.errorMessage!.isNotEmpty &&
          (isNowError && wasLoading)) {
        AppSnackBar.showError(context, message: next.errorMessage!);
      }

      if (next.status == AuthStatus.passwordResetEmailSent &&
          previous?.status != AuthStatus.passwordResetEmailSent) {
        AppSnackBar.showSuccess(
          context,
          message: 'Password reset email sent successfully!',
        );
      }
    });

    // If initial check already determined a redirect, show loader until GoRouter navigates
    // This is a bit tricky because the redirect might happen before this build method
    // if the initial check is very fast. A global redirect is often cleaner for this.
    // However, if SplashScreen always navigates here, this screen *will* build.
    // If _initialAuthCheckDone is false AND authState indicates loading from checkCurrentUser, show loader.
    if (!_initialAuthCheckDone &&
        (authState.status == AuthStatus.loading && authState.user == null)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _isLogin ? 'Welcome Back!' : 'Create Account',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin ? 'Login to continue' : 'Sign up to get started',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (!_isLogin && value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                if (authState.isLoadingSignIn || authState.isLoadingSignUp)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        final authNotifierInstance = ref.read(
                          authNotifierProvider.notifier,
                        );
                        if (_isLogin) {
                          authNotifierInstance.signInWithEmailPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        } else {
                          authNotifierInstance.signUpWithEmailPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        }
                      }
                    },
                    child: Text(
                      _isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'Need an account?' : 'Have an account?',
                      style: TextStyle(color: theme.colorScheme.outline),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          _formKey.currentState?.reset();
                          _emailController.clear();
                          _passwordController.clear();
                        });
                      },
                      child: Text(
                        _isLogin ? 'Sign Up' : 'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isLogin)
                  TextButton(
                    onPressed: _showForgotPasswordDialog,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
