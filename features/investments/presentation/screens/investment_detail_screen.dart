import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/investment_repository.dart';
import '../../domain/entities/investment.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_text_form_field.dart';

class InvestmentDetailScreen extends StatefulWidget {
  final Investment investment;

  const InvestmentDetailScreen({
    super.key,
    required this.investment,
  });

  @override
  State<InvestmentDetailScreen> createState() => _InvestmentDetailScreenState();
}

class _InvestmentDetailScreenState extends State<InvestmentDetailScreen> {
  late Investment _investment;

  @override
  void initState() {
    super.initState();
    _investment = widget.investment;
  }

  void _handleAddReturn(ReturnEntry returnEntry) {
    InvestmentRepository().addReturnEntry(_investment.id, returnEntry);
    setState(() {
      _investment.returns.add(returnEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_investment.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInvestmentInfo(),
            const SizedBox(height: 24),
            _buildTransactionInfo(),
            const SizedBox(height: 24),
            _buildReturnEntries(),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Investment Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildInfoRow('Amount Invested:',
                '\$${_investment.amountInvested.toStringAsFixed(2)}'),
            _buildInfoRow(
                'Start Date:', _investment.startDate.toLocal().toString().split(' ')[0]),
            _buildInfoRow('Expected End Date:',
                _investment.expectedEndDate.toLocal().toString().split(' ')[0]),
            _buildInfoRow('Platform:', _investment.platformName),
             if (_investment.notes.isNotEmpty)
              _buildInfoRow('Notes:', _investment.notes),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaction Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildInfoRow('Transaction ID:', _investment.transactionId),
            _buildInfoRow('Medium:', _investment.transactionMedium),
            _buildInfoRow('Date:',
                _investment.transactionDate.toLocal().toString().split(' ')[0]),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnEntries() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Return Entries',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddReturnDialog(),
                ),
              ],
            ),
            const Divider(),
            if (_investment.returns.isEmpty)
              const Text('No return entries yet.')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _investment.returns.length,
                itemBuilder: (context, index) {
                  final returnEntry = _investment.returns[index];
                  return ListTile(
                    title: Text(
                        'Amount: \$${returnEntry.amountReceived.toStringAsFixed(2)}'),
                    subtitle: Text(
                        'Date: ${returnEntry.date.toLocal().toString().split(' ')[0]}'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value, textAlign: TextAlign.end,)),
        ],
      ),
    );
  }

  void _showAddReturnDialog() {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final transactionIdController = TextEditingController();
    final notesController = TextEditingController();
    DateTime? returnDate;
    String? medium;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Return Entry'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        controller: amountController,
                        labelText: 'Amount Received *',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                           if (value == null || value.isEmpty) return 'This field is required';
                           if (double.tryParse(value) == null || double.parse(value) <= 0) {
                             return 'Enter a valid amount';
                           }
                           return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomDatePicker(
                        labelText: 'Date *',
                        selectedDate: returnDate,
                        onDateSelected: (date) => setState(() => returnDate = date),
                        validator: (value) => value == null ? 'This field is required' : null,
                      ),
                       const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: transactionIdController,
                        labelText: 'Transaction ID *',
                         validator: (value) =>
                    value == null || value.isEmpty ? 'This field is required' : null,
                      ),
                       const SizedBox(height: 16),
                       DropdownButtonFormField<String>(
                        value: medium,
                        decoration: const InputDecoration(
                          labelText: 'Medium *',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Bank Transfer', 'bKash', 'MSF', 'Other']
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (value) => setState(() => medium = value),
                         validator: (value) => value == null ? 'Please select a method' : null,
                      ),
                       const SizedBox(height: 16),
                       CustomTextFormField(
                        controller: notesController,
                        labelText: 'Notes',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                   if (returnDate == null || medium == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields')),
                    );
                    return;
                  }
                  final newReturn = ReturnEntry(
                    id: DateTime.now().toString(),
                    amountReceived: double.parse(amountController.text),
                    date: returnDate!,
                    transactionId: transactionIdController.text,
                    medium: medium!,
                    notes: notesController.text,
                  );
                  _handleAddReturn(newReturn);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}