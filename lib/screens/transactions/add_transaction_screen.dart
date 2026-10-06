import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_backend_app_2/models/contact_model.dart';
import 'package:my_backend_app_2/providers/contact_provider.dart';
import 'package:my_backend_app_2/screens/contacts/add_contact_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_backend_app_2/screens/utils/colors.dart';
import 'package:my_backend_app_2/providers/transaction_provider.dart';
import 'package:my_backend_app_2/models/transaction_model.dart';


class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _type = TransactionType.taken; // borrow
  String _contactId = "";
  // String? _contactName;
  ContactModel? _selectedContact;
  double _amount = 0;
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _interestCtrl = TextEditingController();
  final TextEditingController _remarkCtrl = TextEditingController();
  InterestType _interestType = InterestType.yearly;
  DateTime? _startDate;
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashColors.background,
      appBar: AppBar(
        backgroundColor: DashColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DashColors.mainText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add New Transaction', style: dashText(18, FontWeight.w800, DashColors.mainText)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select transaction type:', style: dashText(14, FontWeight.w600, DashColors.mainText)),
            const SizedBox(height: 8),
            Row(
              children: [
                _radioOption('Borrow', TransactionType.taken),
                const SizedBox(width: 24),
                _radioOption('Lend', TransactionType.given),
              ],
            ),
            const SizedBox(height: 24),
            Text(_type == TransactionType.taken ? 'Choose Borrower' : 'Choose Lender' ,
              style: dashText(
                14,
                FontWeight.w600,
                DashColors.mainText,
              ),
            ),

            const SizedBox(height: 8),

            Autocomplete<ContactModel>(
              displayStringForOption: (contact) => contact.name,

              optionsBuilder: (TextEditingValue textEditingValue) {
                final contacts = context.read<ContactProvider>().contacts;

                final query = textEditingValue.text.trim().toLowerCase();

                if (query.isEmpty) {
                  return const Iterable<ContactModel>.empty();
                }
                return contacts.where(
                  (contact) => contact.name
                                      .toLowerCase()
                                      .contains(query),
                );
              },

              onSelected: (ContactModel contact) {
                setState(() {
                  _selectedContact = contact;
                  _contactId = contact.id;
                });
              },

              fieldViewBuilder: (
                context,
                controller,
                focusNode,
                onFieldSubmitted,
              ) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (_) {
                    if (_selectedContact != null) {
                      setState(() {
                        _selectedContact = null;
                        _contactId = '';
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search contact...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            controller.clear();

                            setState(() {
                              _selectedContact = null;
                              _contactId = '';
                            });
                          },
                        )
                      : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },

              optionsViewBuilder: (
                context,
                onSelected,
                options,
              ) {
                final optionsList = options.toList();
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 300,
          ),

          child: optionsList.isEmpty
              ? InkWell(
                  onTap: () async {
                    // Open Add Contact screen.
                    final newContact = await Navigator.push<ContactModel>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddContactScreen(),
                      ),
                    );

                    if (!context.mounted) return;

                    // If AddContactScreen returns the newly-created
                    // ContactModel, select it automatically.
                    if (newContact != null) {
                      onSelected(newContact);
                    }
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: DashColors.blueSoft,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_add,
                            color: DashColors.blue,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No contact found',
                                style: dashText(
                                  14,
                                  FontWeight.w600,
                                  DashColors.mainText,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                'Tap to add a new contact',
                                style: dashText(
                                  12,
                                  FontWeight.w400,
                                  DashColors.subText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(
                          Icons.add,
                          color: DashColors.blue,
                        ),
                      ],
                    ),
                  ),
                )

              : ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: optionsList.length,
                  itemBuilder: (context, index) {
                    final contact = optionsList[index];

                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),

                      title: Text(
                        contact.name,
                        style: dashText(
                          14,
                          FontWeight.w600,
                          DashColors.mainText,
                        ),
                      ),

                      subtitle: Text(
                        contact.mobile,
                        style: dashText(
                          12,
                          FontWeight.w400,
                          DashColors.subText,
                        ),
                      ),

                      onTap: () {
                        onSelected(contact);
                      },
                    );
                  },
                ),
        ),
      ),
    );
  },
),
                  // contact end
            const SizedBox(height: 24),
            Text('Choose amount:', style: dashText(14, FontWeight.w600, DashColors.mainText)),
            const SizedBox(height: 8),
            Row(
              children: [
                _amountChip(1000),
                const SizedBox(width: 8),
                _amountChip(5000),
                const SizedBox(width: 8),
                _amountChip(10000),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildContainer(
                    child: TextField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration.collapsed(
                        hintText: 'other...',
                        hintStyle: dashText(14, FontWeight.w500, DashColors.subText),
                      ),
                      onChanged: (v) => setState(() => _amount = double.tryParse(v) ?? 0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Interest :', style: dashText(14, FontWeight.w600, DashColors.mainText)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildContainer(
                    child: TextField(
                      controller: _interestCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration.collapsed(hintText: '12'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text('%', style: dashText(14, FontWeight.w600, DashColors.mainText)),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: _buildContainer(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<InterestType>(
                        value: _interestType,
                        isExpanded: true,
                        isDense: true,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                        items: const [
                          DropdownMenuItem(value: InterestType.yearly, child: Text('yearly')),
                          DropdownMenuItem(value: InterestType.monthly, child: Text('monthly')),
                        ],
                        onChanged: (v) => setState(() => _interestType = v!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Date:', style: dashText(14, FontWeight.w600, DashColors.mainText)),
                      const SizedBox(height: 8),
                      _datePickerContainer(_startDate, (d) => setState(() => _startDate = d)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Due Date:', style: dashText(14, FontWeight.w600, DashColors.mainText)),
                      const SizedBox(height: 8),
                      _datePickerContainer(_dueDate, (d) => setState(() => _dueDate = d)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Remark:', style: dashText(14, FontWeight.w600, DashColors.mainText)),
            const SizedBox(height: 8),
            _buildContainer(
              height: 100,
              child: TextField(
                controller: _remarkCtrl,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type here...',
                  hintStyle: dashText(14, FontWeight.w500, DashColors.subText),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DashColors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Save', style: dashText(16, FontWeight.w700, Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radioOption(String label, TransactionType value) {
    return InkWell(
      onTap: () => setState(() => _type = value),
      child: Row(
        children: [
          Radio<TransactionType>(
            value: value,
            groupValue: _type,
            onChanged: (v) => setState(() => _type = v!),
            activeColor: DashColors.blue,
          ),
          Text(label, style: dashText(14, FontWeight.w500, DashColors.mainText)),
        ],
      ),
    );
  }

  Widget _amountChip(double val) {
    final selected = _amount == val;
    return InkWell(
      onTap: () {
        setState(() {
          _amount = val;
          _amountCtrl.text = ''; // Clear other text
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? DashColors.blueSoft : Colors.transparent,
          border: Border.all(color: selected ? DashColors.blue : DashColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(NumberFormat('#,##0').format(val),
            style: dashText(14, FontWeight.w500, selected ? DashColors.blue : DashColors.mainText)),
      ),
    );
  }

  Widget _buildContainer({required Widget child, double? height}) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DashColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _datePickerContainer(DateTime? date, ValueChanged<DateTime> onPicked) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (d != null) onPicked(d);
      },
      child: _buildContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date == null ? 'DD/MM/YYYY' : DateFormat('dd/MM/yyyy').format(date),
                style: dashText(12, FontWeight.w500, date == null ? DashColors.subText : DashColors.mainText)),
            const Icon(Icons.calendar_today_outlined, size: 16, color: DashColors.subText),
          ],
        ),
      ),
    );
  }

  void _saveTransaction() async {
    if (kDebugMode) {
      print("save started");
    }
    final provider = context.read<TransactionProvider>();
    final interestStr = _interestCtrl.text;
    final interestRate = double.tryParse(interestStr) ?? 0;
    
    // In a real app, you'd want proper form validation here
    if (kDebugMode) {
      print("calling add Transactions");
    }
    await provider.addTransaction(
      contactId: _contactId,
      amount: _amount,
      type: _type,
      interestRate: interestRate,
      interestType: _interestType,
      startDate: _startDate ?? DateTime.now(),
      dueDate: _dueDate,
      notes: _remarkCtrl.text,
    );
    
    if (kDebugMode) {
      print("add transaction successful");
    }
    Navigator.pop(context);
}

}
