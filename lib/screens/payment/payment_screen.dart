import 'package:flutter/material.dart';
import 'package:my_backend_app_2/models/transaction_model.dart';
import 'package:my_backend_app_2/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final String contactId;
  final String contactName;

  const PaymentScreen({
    super.key,
    required this.contactId,
    required this.contactName,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}



class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _notesController = TextEditingController();

  TransactionType _type = TransactionType.given;
  InterestType _interestType = InterestType.monthly;
  DateTime _startDate = DateTime.now();
  DateTime? _dueDate;

  @override
  void dispose() {
    _amountController.dispose();
    _interestRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : (_dueDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<TransactionProvider>().addTransaction(
          contactId: widget.contactId,
          amount: double.parse(_amountController.text.trim()),
          type: _type,
          interestRate: double.parse(_interestRateController.text.trim()),
          interestType: _interestType,
          startDate: _startDate,
          dueDate: _dueDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    if (mounted) Navigator.pop(context);
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Transaction — ${widget.contactName}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Given / Taken toggle
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(
                    value: TransactionType.given,
                    label: Text('I Gave'),
                    icon: Icon(Icons.call_made),
                  ),
                  ButtonSegment(
                    value: TransactionType.taken,
                    label: Text('I Took'),
                    icon: Icon(Icons.call_received),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Amount is required';
                  if (double.tryParse(v.trim()) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _interestRateController,
                      decoration: const InputDecoration(labelText: 'Interest Rate (%)'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (double.tryParse(v.trim()) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<InterestType>(
                      initialValue: _interestType,
                      decoration: const InputDecoration(labelText: 'Per'),
                      items: const [
                        DropdownMenuItem(
                          value: InterestType.monthly,
                          child: Text('Month'),
                        ),
                        DropdownMenuItem(
                          value: InterestType.yearly,
                          child: Text('Year'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _interestType = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Start Date'),
                subtitle: Text(_formatDate(_startDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(isStartDate: true),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due Date (optional)'),
                subtitle: Text(_dueDate == null ? 'Not set' : _formatDate(_dueDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(isStartDate: false),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Save Transaction'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}