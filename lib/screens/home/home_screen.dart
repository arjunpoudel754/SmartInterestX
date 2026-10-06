import 'package:flutter/material.dart';
import 'package:my_backend_app_2/screens/contacts/contact_list_screen.dart';
import 'package:my_backend_app_2/screens/dashboard/dashboard_screen.dart';
import 'package:my_backend_app_2/screens/transactions/transaction_list_screen.dart';
import 'package:my_backend_app_2/screens/dashboard/analytics_screen.dart';
import 'package:my_backend_app_2/screens/settings/settings_screen.dart';
import 'package:my_backend_app_2/screens/widgets/dashboard_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    TransactionListScreen(),
    AnalyticsScreen(),
    ContactListScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _navIndex,
        children: _pages,
      ),
      bottomNavigationBar: DashNavBar(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
        },
      ),
    );
  }
}
