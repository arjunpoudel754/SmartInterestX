import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_backend_app_2/screens/utils/colors.dart';
import 'package:my_backend_app_2/screens/widgets/dashboard_widgets.dart';
import 'package:my_backend_app_2/providers/transaction_provider.dart';
import 'package:my_backend_app_2/models/transaction_model.dart';

/// Values the dashboard displays. Replace [DashboardSummary.sample()] with
/// numbers computed from your TransactionProvider / ContactProvider.
class DashboardSummary {
  final String monthLabel;
  final int activeRelationships;
  final double totalGiven, givenLastMonth;
  final double totalTaken, takenLastMonth;
  final double interestEarned, interestPaid;
  final double receivable, payable;

  const DashboardSummary({
    required this.monthLabel,
    required this.activeRelationships,
    required this.totalGiven,
    required this.givenLastMonth,
    required this.totalTaken,
    required this.takenLastMonth,
    required this.interestEarned,
    required this.interestPaid,
    required this.receivable,
    required this.payable,
  });

  factory DashboardSummary.sample() => const DashboardSummary(
        monthLabel: 'April 2026',
        activeRelationships: 12,
        totalGiven: 100,
        givenLastMonth: 40,
        totalTaken: 100,
        takenLastMonth: 0,
        interestEarned: 500,
        interestPaid: 500,
        receivable: 1840,
        payable: 250,
      );
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.transactions;
        
        // Calculate totals dynamically based on transactions
        double totalGiven = 0;
        double totalTaken = 0;
        double givenLastMonth = 0; // Mock calculation
        double takenLastMonth = 0;
        double interestEarned = 0; // Mock calculation
        double interestPaid = 0; // Mock calculation
        double receivable = 0;
        double payable = 0;
        
        for (var t in transactions) {
          if (t.type == TransactionType.given) {
            totalGiven += t.amount;
            if (t.status != TransactionStatus.settled) {
              receivable += t.amount;
            }
          } else {
            totalTaken += t.amount;
            if (t.status != TransactionStatus.settled) {
              payable += t.amount;
            }
          }
        }

        final s = DashboardSummary(
          monthLabel: DateFormat('MMMM yyyy').format(DateTime.now()),
          activeRelationships: transactions.map((e) => e.contactId).toSet().length,
          totalGiven: totalGiven,
          givenLastMonth: givenLastMonth,
          totalTaken: totalTaken,
          takenLastMonth: takenLastMonth,
          interestEarned: interestEarned,
          interestPaid: interestPaid,
          receivable: receivable,
          payable: payable,
        );

        return Scaffold(
          backgroundColor: DashColors.background,
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                const DashAppBar(),
                const SizedBox(height: 22),
                _overviewCard(s),
                const SizedBox(height: 22),
                // _filters(),
                // const SizedBox(height: 22),
                _recentTransactions(transactions),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _overviewCard(DashboardSummary s) {
    return DashCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overview',
                        style: dashText(
                            18, FontWeight.w700, DashColors.mainText)),
                    const SizedBox(height: 2),
                    Text(
                        '${s.monthLabel} • ${s.activeRelationships} active relationships',
                        style: dashText(
                            12, FontWeight.w500, DashColors.subText)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: DashColors.blueSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user_outlined,
                        size: 14, color: DashColors.blue),
                    const SizedBox(width: 8),
                    Text('Healthy',
                        style:
                            dashText(12, FontWeight.w700, DashColors.blue)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TotalsRow(
            givenAmount: _money(s.totalGiven),
            takenAmount: _money(s.totalTaken),
          ),
          const SizedBox(height: 12),
          _pair(
            StatTile(
              title: 'Interest Earned',
              amount: _money(s.interestEarned),
              background: DashColors.successBg,
              accent: DashColors.success,
              remarkColor: DashColors.success,
            ),
            StatTile(
              title: 'Interest Paid',
              amount: _money(s.interestPaid),
              background: DashColors.dangerBg,
              accent: DashColors.danger,
            ),
          ),
          const SizedBox(height: 12),
          _pair(
            StatTile(
              title: 'Receivable Amount',
              amount: _money(s.receivable),
              background: DashColors.pendingBg,
              accent: DashColors.orange,
            ),
            StatTile(
              title: 'Payable Amount',
              amount: _money(s.payable),
              background: DashColors.purpleBg,
              accent: DashColors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pair(Widget a, Widget b) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: a),
            const SizedBox(width: 12),
            Expanded(child: b),
          ],
        ),
      );

  // Widget _filters() {
  //   return const Row(
  //     children: [
  //       Expanded(
  //           child: FilterChipBox(
  //               icon: Icons.calendar_today_outlined, label: 'April')),
  //       SizedBox(width: 8),
  //       Expanded(
  //           child: FilterChipBox(
  //               icon: Icons.calendar_today_outlined, label: '2026')),
  //       SizedBox(width: 8),
  //       Expanded(
  //           child: FilterChipBox(
  //               icon: Icons.people_outline, label: 'All contacts')),
  //     ],
  //   );
  // }

  Widget _recentTransactions(List<TransactionModel> transactions) {
    return DashCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent transactions',
                  style:
                      dashText(18, FontWeight.w700, DashColors.mainText)),
              Text('${transactions.length} this week',
                  style: dashText(12, FontWeight.w600, DashColors.blue)),
            ],
          ),
          const SizedBox(height: 12),
          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('No transactions yet', style: dashText(14, FontWeight.w500, DashColors.subText)),
            ),
          ...transactions.take(5).map((t) {
            final isLent = t.type == TransactionType.given;
            final tone = t.status == TransactionStatus.settled ? TxTone.green :
                         t.status == TransactionStatus.active ? TxTone.orange : TxTone.red; // active=pending, partiallyPaid=red?
            final formattedAmount = NumberFormat.currency(symbol: '\$').format(t.amount);
            final prefix = isLent ? '+' : '-';
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TransactionRow(
                name: 'Contact ${t.contactId}',
                subtitle: '${isLent ? 'Interest received' : 'Interest paid'} • ${DateFormat('MMM dd').format(t.startDate)}',
                amount: '$prefix$formattedAmount',
                status: t.status.name.toUpperCase(),
                icon: isLent ? Icons.north_east : Icons.south_west,
                tone: tone,
              ),
            );
          }),
        ],
      ),
    );
  }
}