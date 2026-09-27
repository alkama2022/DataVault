import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import '../wallet/wallet_screen.dart';
import '../transactions/transactions_screen.dart';
import '../profile/profile_screen.dart';

/// Main app shell hosting the four primary tabs with a bottom nav bar.
class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  /// Allows descendants (e.g. the drawer) to switch tabs programmatically.
  static _DashboardTabState? of(BuildContext context) =>
      context.findAncestorStateOfType<_DashboardTabState>();

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  int _currentIndex = 0;

  void switchToTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeScreen(),
      WalletScreen(),
      TransactionsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: switchToTab,
      ),
    );
  }
}
