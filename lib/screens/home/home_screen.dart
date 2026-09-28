import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../models/service_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/service_grid_item.dart';
import '../../widgets/stat_card.dart';

/// Home dashboard: greeting, wallet banner, gradient stat cards and the
/// services grid — combining the mobile and desktop dashboard references.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadDashboard();
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final wallet = context.watch<WalletProvider>();
    final user = auth.user;
    final balance = NumberFormat('#,##0.00').format(wallet.walletBalance);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => wallet.loadDashboard(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.menu_rounded,
                          color: AppColors.textPrimary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_greeting()},',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user?.fullName ?? 'User',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/search'),
                    icon: const Icon(Icons.search_rounded,
                        color: AppColors.textPrimary),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/notifications'),
                    icon: Badge(
                      smallSize: 8,
                      child: const Icon(Icons.notifications_none_rounded,
                          color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Wallet banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.navy, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      AppStrings.walletBalance,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₦$balance',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _bannerAction(
                            label: AppStrings.fundWallet,
                            icon: Icons.add_card_rounded,
                            bg: AppColors.primary,
                            onTap: () => Navigator.pushNamed(context, '/wallet'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _bannerAction(
                            label: AppStrings.upgrade,
                            icon: Icons.arrow_circle_up_rounded,
                            bg: AppColors.gold,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            AppStrings.earnings,
                            style: TextStyle(color: Colors.white70, fontSize: 12.5),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '₦${NumberFormat('#,##0.00').format(wallet.earnings)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/wallet'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                AppStrings.withdraw,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stat cards grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.55,
                children: [
                  StatCard(
                    title: AppStrings.accountBalance,
                    amount: '₦$balance',
                    icon: Icons.account_balance_rounded,
                    gradient: AppColors.statGradients[0],
                  ),
                  StatCard(
                    title: AppStrings.endUserPlan,
                    amount: user?.currentPlan ?? 'Free Plan',
                    icon: Icons.sim_card_rounded,
                    gradient: AppColors.statGradients[1],
                  ),
                  StatCard(
                    title: AppStrings.totalWalletApproved,
                    amount: '₦$balance',
                    icon: Icons.verified_rounded,
                    gradient: AppColors.statGradients[2],
                  ),
                  StatCard(
                    title: AppStrings.totalTransaction,
                    amount: '${wallet.transactions.length}',
                    icon: Icons.receipt_long_rounded,
                    gradient: AppColors.statGradients[3],
                  ),
                  StatCard(
                    title: AppStrings.thisMonthFunding,
                    amount: '₦0.00',
                    icon: Icons.south_west_rounded,
                    gradient: AppColors.statGradients[4],
                  ),
                  StatCard(
                    title: AppStrings.thisMonthExpenditure,
                    amount: '₦0.00',
                    icon: Icons.north_east_rounded,
                    gradient: AppColors.statGradients[5],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Wema account note
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.goldLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.gold, size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        AppStrings.generateWema,
                        style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        AppStrings.generate,
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Services
              const Text(
                AppStrings.ourServices,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
                children: ServiceCatalog.all
                    .map((s) => ServiceGridItem(
                          service: s,
                          onTap: () => Navigator.pushNamed(context, s.route),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerAction({
    required String label,
    required IconData icon,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
