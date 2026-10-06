import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_backend_app_2/screens/utils/colors.dart';
import 'package:my_backend_app_2/screens/widgets/dashboard_widgets.dart';
import 'package:my_backend_app_2/providers/transaction_provider.dart';
import 'package:my_backend_app_2/models/transaction_model.dart';
import 'package:my_backend_app_2/screens/transactions/add_transaction_screen.dart';
import 'package:my_backend_app_2/screens/transactions/transaction_details_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  String _selectedFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashColors.background,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70), // Avoid nav bar overlap
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
            );
          },
          backgroundColor: DashColors.blue,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            final transactions = provider.transactions.where((transaction) {
              if (_selectedFilter == 'Lent') {
                return transaction.type == TransactionType.given;
              }
              if (_selectedFilter == 'Borrowed') {
                return transaction.type != TransactionType.given;
              }
              return true;
            }).toList();
            
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                const DashAppBar(),
                const SizedBox(height: 22),
                TextField(
                  
                  decoration: InputDecoration(
                    
                    hintText: 'Search Transactions...',
                    hintStyle: dashText(14, FontWeight.w500, DashColors.subText),
                    suffixIcon: const Icon(Icons.search, color: DashColors.subText, size: 28),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: DashColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: DashColors.border),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _filterChip('ALL'),
                    const SizedBox(width: 10),
                    _filterChip('Lent'),
                    const SizedBox(width: 10),
                    _filterChip('Borrowed'),
                  ],
                ),
                const SizedBox(height: 22),
                DashCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent transactions', style: dashText(18, FontWeight.w700, DashColors.mainText)),
                          Row(
                            children: [
                              Text('export ', style: dashText(12, FontWeight.w600, DashColors.blue)),
                              const Icon(Icons.arrow_forward, size: 14, color: DashColors.blue),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (transactions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('No transactions found', style: dashText(14, FontWeight.w500, DashColors.subText)),
                        ),
                      ...transactions.map((t) {
                        final isLent = t.type == TransactionType.given;
                        final tone = t.status == TransactionStatus.settled ? TxTone.green :
                                     t.status == TransactionStatus.active ? TxTone.orange : TxTone.red; 
                        final formattedAmount = NumberFormat.currency(symbol: '\$').format(t.amount);
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => TransactionDetailsScreen(transaction: t)),
                              );
                            },
                            child: TransactionRow(
                              name: 'Contact ${t.contactId}', 
                              subtitle: isLent ? 'Lent' : 'Borrowed',
                              amount: formattedAmount,
                              status: t.status.name.toUpperCase(),
                              icon: isLent ? Icons.north_east : Icons.south_west,
                              tone: tone,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    return ChoiceChip(
      label: Text(label, style: dashText(13, FontWeight.w700, DashColors.mainText)),
      selected: _selectedFilter == label,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = label);
        }
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.white,
      side: const BorderSide(color: DashColors.border),
      shape: const StadiumBorder(),
    );
  }
}
