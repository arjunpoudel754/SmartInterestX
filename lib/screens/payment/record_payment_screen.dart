import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_backend_app_2/screens/utils/colors.dart';
import 'package:my_backend_app_2/providers/transaction_provider.dart';
import 'package:my_backend_app_2/models/payment_model.dart';

class RecordPaymentScreen extends StatefulWidget {
  final String transactionId;

  const RecordPaymentScreen({super.key, required this.transactionId});

  @override
  State<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends State<RecordPaymentScreen> {
  double _amount = 0;
  final TextEditingController _amountCtrl = TextEditingController();
  DateTime _paymentDate = DateTime.now();
  PaymentMode _mode = PaymentMode.upi;

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
        title: Text('Record Payment', style: dashText(18, FontWeight.w800, DashColors.mainText)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AMOUNT PAID', style: dashText(12, FontWeight.w700, DashColors.subText)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('₹ ', style: dashText(32, FontWeight.w800, DashColors.mainText)),
                      Expanded(
                        child: TextField(
                          controller: _amountCtrl,
                          keyboardType: TextInputType.number,
                          style: dashText(32, FontWeight.w800, DashColors.mainText),
                          decoration: const InputDecoration.collapsed(hintText: '5,000'),
                          onChanged: (v) => setState(() => _amount = double.tryParse(v) ?? 0),
                        ),
                      ),
                      const Icon(Icons.edit, color: DashColors.blue, size: 20),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Payment Date', style: dashText(14, FontWeight.w700, DashColors.mainText)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _paymentDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => _paymentDate = d);
              },
              child: _buildContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd MMMM yyyy').format(_paymentDate), style: dashText(14, FontWeight.w500, DashColors.mainText)),
                    const Icon(Icons.calendar_today_outlined, size: 18, color: DashColors.subText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Payment Method', style: dashText(14, FontWeight.w700, DashColors.mainText)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _paymentMethodOption('UPI', PaymentMode.upi, Icons.phone_android)),
                const SizedBox(width: 8),
                Expanded(child: _paymentMethodOption('Bank Transfer', PaymentMode.bankTransfer, Icons.account_balance)),
                const SizedBox(width: 8),
                Expanded(child: _paymentMethodOption('Cash', PaymentMode.cash, Icons.money)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Payment Proof', style: dashText(14, FontWeight.w700, DashColors.mainText)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: DashColors.background,
                border: Border.all(color: DashColors.border, style: BorderStyle.solid), // Should be dashed, keeping simple
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: DashColors.blueSoft, shape: BoxShape.circle),
                    child: const Icon(Icons.attach_file, color: DashColors.blue),
                  ),
                  const SizedBox(height: 12),
                  Text('Upload Receipt / Screenshot', style: dashText(14, FontWeight.w600, DashColors.blue)),
                  const SizedBox(height: 4),
                  Text('Supports PDF, JPG, PNG up to 10MB', style: dashText(12, FontWeight.w500, DashColors.subText)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DashColors.successBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_outlined, color: DashColors.success, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('This transaction will update your principal interest cycle instantly.', 
                      style: dashText(12, FontWeight.w600, DashColors.success)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _savePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DashColors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Save Payment', style: dashText(16, FontWeight.w700, Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodOption(String label, PaymentMode mode, IconData icon) {
    final selected = _mode == mode;
    return InkWell(
      onTap: () => setState(() => _mode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? DashColors.blueSoft : Colors.white,
          border: Border.all(color: selected ? DashColors.blue : DashColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? DashColors.blue : DashColors.subText),
            const SizedBox(height: 8),
            Text(label, style: dashText(12, FontWeight.w600, selected ? DashColors.blue : DashColors.mainText), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DashColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  void _savePayment() async {
    final provider = context.read<TransactionProvider>();
    await provider.recordPayment(
      transactionId: widget.transactionId,
      amount: _amount,
      mode: _mode,
      proofImagePath: 'screenshot.png', // mock file attachment
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
