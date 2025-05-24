import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/features/sales/domain/entities/sale_entity.dart';

import '../../../../core/common/common.dart';

class AddEditSaleScreen extends ConsumerStatefulWidget {
  final SaleEntity? sale;

  const AddEditSaleScreen({super.key, this.sale});

  @override
  ConsumerState<AddEditSaleScreen> createState() => _AddEditSaleScreenState();
}

class _AddEditSaleScreenState extends ConsumerState<AddEditSaleScreen> {
  final _formKey = GlobalKey<FormState>();
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
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.sale == null ? 'Add Sale' : 'Edit Sale'),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Customer Section
              CustomTextFieldWidget(
                controller: _customerPhoneController,
                labelText: 'Customer Phone',
                prefixIcon: const Icon(Icons.phone),
                validator:
                    (value) => value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              // Product Section
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
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedUnit = value);
                        }
                      },
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

              // Date and Payment
              CustomDateSelectorField(
                labelText: 'Sale Date',
                initialDate: _selectedDate,
                onDateSelected: (date) {
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
              ),
              const SizedBox(height: 16),

              CustomSingleSelectDropdownField<String>(
                labelText: 'Payment Method',
                hintText: 'Select method',
                value: _selectedPaymentMethod,
                items: [
                  DropdownOption(value: 'cash', label: 'Cash'),
                  DropdownOption(value: 'card', label: 'Card'),
                  DropdownOption(value: 'transfer', label: 'Bank Transfer'),
                ],
                onChanged:
                    (value) => setState(() => _selectedPaymentMethod = value),
              ),
              const SizedBox(height: 16),

              // Notes
              CustomTextAreaWidget(
                controller: _notesController,
                labelText: 'Notes',
                minLines: 3,
              ),
              const SizedBox(height: 24),

              // Submit Button
              CustomElevatedButton(
                onPressed: _submitForm,
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
    if (_formKey.currentState!.validate()) {
      // Implement form submission logic
      // Either call addSaleUseCase or updateSaleUseCase
      // Show appropriate snackbar on success/error
    }
  }
}
