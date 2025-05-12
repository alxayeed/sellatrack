import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_state.dart';
import 'package:sellatrack/features/auth/presentation/providers/auth_providers.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _emailController;
  late TextEditingController _photoURLController;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authNotifierProvider).user;
    _displayNameController = TextEditingController(
      text: currentUser?.displayName ?? '',
    );
    _emailController = TextEditingController(text: currentUser?.email ?? '');
    _photoURLController = TextEditingController(
      text: currentUser?.photoURL ?? '',
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _photoURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<AuthScreenState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated &&
          previous?.status == AuthStatus.loading &&
          previous!.isLoadingUpdateProfile) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Directly navigate to the profile screen
        context.go(AppRoutePaths.profile);
      }
      if (next.errorMessage != null &&
          next.errorMessage!.isNotEmpty &&
          (previous?.errorMessage != next.errorMessage ||
              previous?.status != next.status)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your display name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoURLController,
                decoration: InputDecoration(
                  labelText: 'Photo URL (Optional)',
                  prefixIcon: const Icon(Icons.link_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final uri = Uri.tryParse(value);
                    if (uri == null ||
                        !uri.hasAbsolutePath ||
                        (!uri.isScheme('http') && !uri.isScheme('https'))) {
                      return 'Please enter a valid URL';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (authState.isLoadingUpdateProfile)
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
                      authNotifier.updateUserProfile(
                        displayName: _displayNameController.text.trim(),
                        email:
                            _emailController.text.trim().isNotEmpty
                                ? _emailController.text.trim()
                                : null,
                        photoURL:
                            _photoURLController.text.trim().isNotEmpty
                                ? _photoURLController.text.trim()
                                : null,
                      );
                    }
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
