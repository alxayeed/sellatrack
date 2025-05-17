import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/presentation/providers/customer_providers.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

// Assuming CustomerListNotifier will also handle updates for now, or a dedicated edit notifier
// import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_state.dart';

class EditCustomerScreen extends ConsumerStatefulWidget {
  final CustomerEntity customerToEdit;

  const EditCustomerScreen({super.key, required this.customerToEdit});

  @override
  ConsumerState<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends ConsumerState<EditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _notesController;

  // photoUrl update would involve image picking and storage upload, complex for this step
  // String? _currentPhotoUrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customerToEdit.name);
    _phoneController = TextEditingController(
      text: widget.customerToEdit.phoneNumber,
    );
    _addressController = TextEditingController(
      text: widget.customerToEdit.address,
    );
    _emailController = TextEditingController(
      text: widget.customerToEdit.email ?? '',
    );
    _notesController = TextEditingController(
      text: widget.customerToEdit.notes ?? '',
    );
    // _currentPhotoUrl = widget.customerToEdit.photoUrl;
  }

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

      // We need an updateCustomer method in CustomerListNotifier or a dedicated notifier
      // For now, let's assume CustomerListNotifier has it.
      final success = await ref
          .read(customerListNotifierProvider.notifier)
          .updateCustomer(
            // The updateCustomer method in notifier will need to take CustomerEntity
            // or individual fields. Let's assume it takes an entity.
            widget.customerToEdit.copyWith(
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
              // photoUrl: _currentPhotoUrl, // If handling photo updates
              lastUpdatedBy: ref.read(authNotifierProvider).user?.uid,
              // Example of getting current user for updatedBy
              updatedAt: DateTime.now(),
            ),
          );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        AppSnackBar.showSuccess(
          context,
          message: 'Customer updated successfully!',
        );
        // Go back to detail screen, or list screen. Pop is often good here.
        if (context.canPop()) {
          context.pop();
        } else {
          // Fallback, though ideally we came from somewhere we can pop to.
          // context.go(AppRoutePaths.customerDetail, extra: updatedCustomerEntity); // if update returns entity
          context.go(AppRoutePaths.customers); // Go to list
        }
      } else {
        // Error SnackBar would be shown by a listener on customerListNotifierProvider
        // if its state updates with an error message.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final customerListState = ref.watch(customerListNotifierProvider); // For error listening

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.customerToEdit.name}'),
        centerTitle: true,
      ),
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
                  if (value.length < 10) return 'Invalid contact number';
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
              if (_isLoading) // Or watch a specific loading state from notifier
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt_outlined),
                  label: const Text('Save Changes'),
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
