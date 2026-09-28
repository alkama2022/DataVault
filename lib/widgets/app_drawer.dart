import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../providers/auth_provider.dart';
import '../screens/home/dashboard_tab.dart';
import '../screens/services/airtime_screen.dart';
import '../screens/services/cable_tv_screen.dart';
import '../screens/services/data_screen.dart';
import '../screens/services/education_screen.dart';
import '../screens/services/electricity_screen.dart';
import '../screens/transactions/transactions_screen.dart';
import '../screens/wallet/wallet_screen.dart';

/// Navigation drawer listing all services (mirrors the desktop sidebar).
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.navy, AppColors.navyLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shield_rounded, color: AppColors.gold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.fullName ?? 'Guest',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _item(context, Icons.dashboard_rounded, 'Dashboard', () {
                    Navigator.pop(context);
                  }),
                  _divider('Services'),
                  _item(context, Icons.phone_android_rounded, 'Buy Airtime', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AirtimeScreen()));
                  }),
                  _item(context, Icons.wifi_rounded, 'Buy Data', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const DataScreen()));
                  }),
                  _item(context, Icons.tv_rounded, 'TV Subscription', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CableTvScreen()));
                  }),
                  _item(context, Icons.bolt_rounded, 'Electricity', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ElectricityScreen()));
                  }),
                  _item(context, Icons.school_rounded, 'Education', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationScreen()));
                  }),
                  _divider('Account'),
                  _item(context, Icons.account_balance_wallet_rounded, 'Wallet', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
                  }),
                  _item(context, Icons.receipt_long_rounded, 'Transactions', () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionsScreen()));
                  }),
                  _item(context, Icons.person_rounded, 'Profile', () {
                    Navigator.pop(context);
                    // Switch to profile tab (index 3)
                    DashboardTab.of(context)?.switchToTab(3);
                  }),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8),
              child: _item(
                context,
                Icons.logout_rounded,
                'Logout',
                color: AppColors.error,
                () async {
                  Navigator.pop(context);
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(String label) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.textMuted,
          ),
        ),
      );

  Widget _item(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary, size: 24),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      dense: true,
    );
  }
}
