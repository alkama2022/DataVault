import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

/// Profile screen with user info, settings, dark mode and logout.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final settings = context.watch<SettingsProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // User card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.navy, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      (user?.fullName ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
                  icon: const Icon(Icons.edit_outlined, color: Colors.white70, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Account
          _sectionTitle('Account'),
          _settingTile(
            context,
            icon: Icons.person_outline_rounded,
            title: 'Edit Profile',
            subtitle: 'Update your name, phone and email',
            onTap: () => Navigator.pushNamed(context, '/edit-profile'),
          ),
          _settingTile(
            context,
            icon: Icons.notifications_outlined,
            title: AppStrings.notifications,
            trailing: Switch(
              value: settings.notificationsEnabled,
              onChanged: (_) => context.read<SettingsProvider>().toggleNotifications(),
              activeColor: AppColors.primary,
            ),
            onTap: () => context.read<SettingsProvider>().toggleNotifications(),
          ),
          _settingTile(
            context,
            icon: Icons.receipt_long_rounded,
            title: 'Transaction Alerts',
            subtitle: 'Get notified after every purchase',
            trailing: Switch(
              value: settings.transactionAlerts,
              onChanged: (_) =>
                  context.read<SettingsProvider>().toggleTransactionAlerts(),
              activeColor: AppColors.primary,
            ),
            onTap: () =>
                context.read<SettingsProvider>().toggleTransactionAlerts(),
          ),
          _settingTile(
            context,
            icon: Icons.local_offer_outlined,
            title: 'Promotional Offers',
            subtitle: 'Receive deals and discounts',
            trailing: Switch(
              value: settings.promotionalOffers,
              onChanged: (_) =>
                  context.read<SettingsProvider>().togglePromotionalOffers(),
              activeColor: AppColors.primary,
            ),
            onTap: () =>
                context.read<SettingsProvider>().togglePromotionalOffers(),
          ),
          const SizedBox(height: 24),

          // Preferences
          _sectionTitle('Preferences'),
          _settingTile(
            context,
            icon: settings.darkMode
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            title: AppStrings.darkMode,
            trailing: Switch(
              value: settings.darkMode,
              onChanged: (_) => context.read<SettingsProvider>().toggleDarkMode(),
              activeColor: AppColors.primary,
            ),
            onTap: () => context.read<SettingsProvider>().toggleDarkMode(),
          ),
          _settingTile(
            context,
            icon: Icons.language_rounded,
            title: AppStrings.language,
            subtitle: 'English',
            onTap: () {},
          ),
          _settingTile(
            context,
            icon: Icons.help_outline_rounded,
            title: AppStrings.helpSupport,
            onTap: () {},
          ),
          _settingTile(
            context,
            icon: Icons.info_outline_rounded,
            title: AppStrings.about,
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Logout
          Container(
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.error),
              title: const Text(
                AppStrings.logout,
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Logout',
                            style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (r) => false);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _settingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textSecondary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
