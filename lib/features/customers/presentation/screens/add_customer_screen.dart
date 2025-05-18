import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/features/customers/presentation/providers/customer_providers.dart';

import '../../../../core/common/components/app_snack_bar.dart';

// Import CustomerListStatus if needed for loading state, though addCustomer returns bool
// import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_state.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  // We won't handle photoUrl upload in this initial screen for simplicity

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final success = await ref
          .read(customerListNotifierProvider.notifier)
          .addCustomer(
            name: _nameController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            email:
                _emailController.text.trim().isNotEmpty
                    ? _emailController.text.trim()
                    : null,
            notes:
                _notesController.text.trim().isNotEmpty
                    ? _notesController.text.trim()
                    : null,
            // photoUrl will be null for now
          );

      if (!mounted) return; // Check if widget is still in tree

      setState(() {
        _isLoading = false;
      });

      if (success) {
        AppSnackBar.showSuccess(
          context,
          message: 'Customer added successfully!',
        );
        context.pop(); // Go back to the previous screen (CustomerListScreen)
      } else {
        // Error SnackBar is already shown by the listener in CustomerListScreen
        // or by the notifier setting its error state, which CustomerListScreen might listen to.
        // For addCustomer, the CustomerListNotifier sets its own state.errorMessage
        // if the add fails. The CustomerListScreen's ref.listen will pick that up.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // We listen to customerListNotifierProvider for general errors if needed,
    // but addCustomer method itself returns a bool and updates the list state.
    // final customerListState = ref.watch(customerListNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Customer'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name*',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  if (value.length < 2) return 'Name too short';
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Contact Number*',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  if (value.length < 10) {
                    return 'Invalid contact number'; // Basic check
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address*',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email (Optional)',
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
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt_outlined),
                  label: const Text('Save Customer'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    textStyle: theme.textTheme.titleMedium,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitForm,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
