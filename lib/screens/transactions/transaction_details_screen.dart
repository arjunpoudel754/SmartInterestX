import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_backend_app_2/models/transaction_model.dart';
import 'package:my_backend_app_2/models/payment_model.dart';
import 'package:my_backend_app_2/screens/utils/colors.dart';
import 'package:my_backend_app_2/screens/payment/record_payment_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_backend_app_2/providers/transaction_provider.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isLent = transaction.type == TransactionType.given;
    final today = DateTime.now();
    final start = transaction.startDate;
    final int monthsDiff = (today.year - start.year) * 12 + (today.month - start.month);
    final double interestRate = transaction.interestRate;
    final double timeInPeriods = transaction.interestType == InterestType.monthly
        ? monthsDiff.toDouble()
        : (monthsDiff / 12.0);
    final double interestTillToday = (transaction.amount * interestRate * timeInPeriods) / 100.0;
    final double totalAmount = transaction.amount + interestTillToday;
    final currency = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: DashColors.background,
      appBar: AppBar(
        backgroundColor: DashColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DashColors.mainText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(transaction.contactId,
                style: dashText(18, FontWeight.w800, DashColors.mainText)),
            Text(isLent ? '(Borrower)' : '(Lender)',
                style: dashText(12, FontWeight.w500, DashColors.subText)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: DashColors.mainText),
            onPressed: () {
              context.read<TransactionProvider>().deleteTransaction(transaction.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_principalInfo(dateFormat, currency, isLent, totalAmount, interestTillToday),
            const SizedBox(height: 32),
            _sectionTitle('Interest Summary'),
            const SizedBox(height: 16),
            _infoRow('Interest till today', currency.format(interestTillToday)),
            const SizedBox(height: 8),
            _infoRow(isLent ? 'Total receivable amount' : 'Total payable amount', currency.format(totalAmount)),
            const SizedBox(height: 8),
            const Divider(color: DashColors.mainText),
            const SizedBox(height: 32),
            _sectionTitle('Payment Status'),
            const SizedBox(height: 16),
            _paymentStatusStream(context,totalAmount, currency, dateFormat),
          ],
        ),
      ),
    );
  }

  Widget _principalInfo(DateFormat dateFormat, NumberFormat currency, bool isLent,
      double totalAmount, double interestTillToday) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashColors.successBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DashColors.successBg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Principal Amount:', style: dashText(14, FontWeight.w500, DashColors.mainText)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: DashColors.successBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(transaction.status.name.toUpperCase(),
                    style: dashText(10, FontWeight.w700, DashColors.success)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(NumberFormat('#,##0').format(transaction.amount),
              style: dashText(20, FontWeight.w700, DashColors.mainText)),
          const SizedBox(height: 12),
          Text('Interest: ${transaction.interestRate.toStringAsFixed(0)}% ${transaction.interestType.name}',
              style: dashText(12, FontWeight.w500, DashColors.mainText)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Start Date: ${dateFormat.format(transaction.startDate)}',
                  style: dashText(12, FontWeight.w500, DashColors.mainText)),
              Text('Due Date: ${transaction.dueDate != null ? dateFormat.format(transaction.dueDate!) : 'N/A'}',
                  style: dashText(12, FontWeight.w500, DashColors.mainText)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Center(child: Text(title, style: dashText(16, FontWeight.w800, DashColors.mainText)));
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: dashText(12, FontWeight.w500, DashColors.mainText)),
        Text(value, style: dashText(12, FontWeight.w500, DashColors.mainText)),
      ],
    );
  }

  Widget _paymentStatusStream(BuildContext context,double totalAmount, NumberFormat currency, DateFormat dateFormat) {
    return StreamBuilder<List<PaymentModel>>(
      stream: context.read<TransactionProvider>().getPaymentsForTransaction(transaction.id),
      builder: (context, snapshot) {
        double paidAmount = 0;
        if (snapshot.hasData) {
          paidAmount = snapshot.data!.fold(0.0, (sum, p) => sum + p.amount);
        }
        double remainingAmount = (totalAmount - paidAmount).clamp(0.0, totalAmount);
        double prog = totalAmount > 0 ? (paidAmount / totalAmount).clamp(0.0, 1.0) : 0.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: prog,
                minHeight: 8,
                backgroundColor: DashColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(DashColors.success),
              ),
            ),
            const SizedBox(height: 16),
            _infoRow('Paid', currency.format(paidAmount)),
            const SizedBox(height: 8),
            _infoRow('Remaining', currency.format(remainingAmount)),
            const SizedBox(height: 8),
            const Divider(color: DashColors.mainText),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 80),
                Text('Payments History', style: dashText(16, FontWeight.w800, DashColors.mainText)),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RecordPaymentScreen(transactionId: transaction.id)),
                    );
                  },
                  child: Row(
                    children: [
                      Text('add payment ', style: dashText(12, FontWeight.w600, DashColors.blue)),
                      const Icon(Icons.arrow_forward, size: 12, color: DashColors.blue),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: DashColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                      color: DashColors.blue,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('Date', style: dashText(12, FontWeight.w600, Colors.white))),
                        Expanded(child: Text('Method', style: dashText(12, FontWeight.w600, Colors.white))),
                        Expanded(child: Text('Amount', style: dashText(12, FontWeight.w600, Colors.white))),
                        Text('Proof', style: dashText(12, FontWeight.w600, Colors.white)),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: DashColors.border),
                  if (snapshot.hasData && snapshot.data!.isNotEmpty)
                    ...snapshot.data!.map((p) => _paymentRow(context,
                        dateFormat.format(p.paymentDate),
                        p.mode.toString().split('.').last.toUpperCase(),
                        currency.format(p.amount),
                        p.proofImagePath))
                  else
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No payments yet.', style: TextStyle(color: Colors.grey)),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _paymentRow(BuildContext context, String date, String method, String amount, String? proofPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(date, style: dashText(12, FontWeight.w500, DashColors.mainText))),
          Expanded(child: Text(method, style: dashText(12, FontWeight.w500, DashColors.mainText))),
          Expanded(child: Text(amount, style: dashText(12, FontWeight.w500, DashColors.mainText))),
          proofPath != null
              ? InkWell(
                  onTap: () => _showProofDialog(context, proofPath),
                  child: const Icon(Icons.insert_drive_file_outlined, size: 16, color: DashColors.mainText),
                )
              : const Icon(Icons.insert_drive_file_outlined, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  void _showProofDialog(BuildContext context, String proofUrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: InteractiveViewer(
          child: Image.network(
            proofUrl,
            fit: BoxFit.contain,
            errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.broken_image, size: 48)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
