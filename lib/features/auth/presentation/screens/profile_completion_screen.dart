import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_state.dart';
import 'package:sellatrack/features/auth/presentation/providers/auth_providers.dart';

class ProfileCompletionScreen extends ConsumerStatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  ConsumerState<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState
    extends ConsumerState<ProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<AuthScreenState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(AppRoutePaths.sales); // Go to sales screen
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
      appBar: AppBar(
        title: const Text('One Last Step!'),
        centerTitle: true,
        automaticallyImplyLeading: false, // No back button here
      ),
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
                  'Complete Your Profile',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please provide a few more details to get started.',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
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
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number (Optional)',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value.length < 10) {
                        return 'Enter a valid contact number';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address (Optional)',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                  maxLines: 2,
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
                          // These fields are not directly part of Firebase Auth User update
                          // without specific flows. If you intend to store them in
                          // Firestore later (Approach B), you'd pass them here.
                          // For now, AuthNotifier's updateUserProfile only handles displayName.
                          // We need to decide if these should be passed to updateUserProfile
                          // and how AuthNotifier/UseCase/Repository/Datasource will handle them.
                          //
                          // For now, only displayName is passed to the existing method.
                          // If you want to pass these, all layers need to be updated.
                        );
                      }
                    },
                    child: const Text(
                      'Save & Continue',
                      style: TextStyle(fontSize: 16),
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
