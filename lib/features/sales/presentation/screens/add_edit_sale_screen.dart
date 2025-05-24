import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/features/sales/domain/entities/sale_entity.dart';
import 'package:sellatrack/features/sales/domain/params/sale_input_data.dart';

import '../../../../core/common/common.dart';
import '../providers/sales_provider.dart';

class AddEditSaleScreen extends ConsumerStatefulWidget {
  final SaleEntity? sale;

  const AddEditSaleScreen({super.key, this.sale});

  @override
  ConsumerState<AddEditSaleScreen> createState() => _AddEditSaleScreenState();
}

class _AddEditSaleScreenState extends ConsumerState<AddEditSaleScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _customerNameController;
  late final TextEditingController _customerAddressController;
  late final TextEditingController _customerPhoneController;
  late final TextEditingController _productNameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late final TextEditingController _notesController;

  late String _selectedUnit;
  late String? _selectedPaymentMethod;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    final sale = widget.sale;

    _customerNameController = TextEditingController(
      text: sale?.customerNameAtSale ?? '',
    );
    _customerAddressController = TextEditingController(
      text: sale?.customerAddressAtSale ?? '',
    );
    _customerPhoneController = TextEditingController(
      text: sale?.customerPhoneAtSale ?? '',
    );
    _productNameController = TextEditingController(
      text: sale?.productDetails.productName ?? '',
    );
    _quantityController = TextEditingController(
      text: sale?.productDetails.quantity.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: sale?.productDetails.saleAmount.toString() ?? '',
    );
    _notesController = TextEditingController(text: sale?.notes ?? '');

    _selectedUnit = sale?.productDetails.unit ?? 'pcs';
    _selectedPaymentMethod = sale?.paymentMethod;
    _selectedDate = sale?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerAddressController.dispose();
    _customerPhoneController.dispose();
    _productNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(addEditSaleNotifierProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFieldWidget(
                controller: _customerNameController,
                labelText: 'Customer Name',
                prefixIcon: const Icon(Icons.person),
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              CustomTextFieldWidget(
                controller: _customerAddressController,
                labelText: 'Customer Address',
                prefixIcon: const Icon(Icons.location_on),
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              CustomTextFieldWidget(
                controller: _customerPhoneController,
                labelText: 'Customer Phone',
                prefixIcon: const Icon(Icons.phone),
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              CustomTextFieldWidget(
                controller: _productNameController,
                labelText: 'Product Name',
                prefixIcon: const Icon(Icons.shopping_bag),
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomNumberInputField(
                      controller: _quantityController,
                      labelText: 'Quantity',
                      validator:
                          (value) =>
                              value?.isEmpty ?? true ? 'Required field' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: CustomSingleSelectDropdownField<String>(
                      labelText: 'Unit',
                      hintText: 'Select unit',
                      value: _selectedUnit,
                      items: [
                        DropdownOption(value: 'pcs', label: 'Pieces'),
                        DropdownOption(value: 'kg', label: 'Kilograms'),
                        DropdownOption(value: 'g', label: 'Grams'),
                        DropdownOption(value: 'l', label: 'Liters'),
                      ],
                      onChanged:
                          (value) => setState(
                            () => _selectedUnit = value ?? _selectedUnit,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomNumberInputField(
                controller: _priceController,
                labelText: 'Price',
                prefixIcon: const Icon(Icons.attach_money),
                allowDecimal: true,
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              CustomDateSelectorField(
                labelText: 'Sale Date',
                initialDate: _selectedDate,
                onDateSelected: (date) {
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 16),

              CustomSingleSelectDropdownField<String>(
                labelText: 'Payment',
                hintText: 'Select Payment',
                value: _selectedPaymentMethod,
                items: [
                  DropdownOption(value: 'paid', label: 'Paid'),
                  DropdownOption(value: 'due', label: 'Due'),
                ],
                onChanged:
                    (value) => setState(() => _selectedPaymentMethod = value),
              ),
              const SizedBox(height: 16),

              CustomTextAreaWidget(
                controller: _notesController,
                labelText: 'Notes',
                minLines: 3,
              ),
              const SizedBox(height: 24),

              CustomElevatedButton(
                onPressed: submitState.isLoading ? null : _submitForm,
                text: widget.sale == null ? 'Record Sale' : 'Update Sale',
                expand: true,
                size: ButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final input = SaleInputData(
      saleDate: _selectedDate,
      customerNameForSale: _customerNameController.text.trim(),
      customerPhoneForSale: _customerPhoneController.text.trim(),
      customerAddressForSale: _customerAddressController.text.trim(),
      customerEmailForSale: null,
      customerPhotoUrlForSale: null,
      productName: _productNameController.text.trim(),
      quantity: num.tryParse(_quantityController.text) ?? 0,
      unit: _selectedUnit,
      saleAmount: double.tryParse(_priceController.text) ?? 0,
      paymentMethod: _selectedPaymentMethod,
      notes:
          _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
      recordedByAppUserId: widget.sale?.recordedBy ?? 'current-user-id',
    );

    final success = await ref
        .read(addEditSaleNotifierProvider.notifier)
        .submitSale(
          isEditing: widget.sale != null,
          input: input,
          existingSale: widget.sale,
        );

    if (success) {
      Navigator.of(context).pop();
      AppSnackBar.showSuccess(
        context,
        message:
            widget.sale == null
                ? "Sale Added successfully"
                : "Sale updated successfully",
      );
    } else {
      final errorState = ref.read(addEditSaleNotifierProvider);
      errorState.whenOrNull(
        error:
            (err, _) => AppSnackBar.showError(context, message: err.toString()),
      );
    }
  }
}
