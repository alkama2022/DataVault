import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_colors.dart';
import 'config/app_theme.dart';
import 'config/app_strings.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/wallet_provider.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/payment_gateway.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/dashboard_tab.dart';
import 'screens/wallet/wallet_screen.dart';
import 'screens/transactions/transactions_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/services/airtime_screen.dart';
import 'screens/services/data_screen.dart';
import 'screens/services/electricity_screen.dart';
import 'screens/services/cable_tv_screen.dart';
import 'screens/services/education_screen.dart';

/// Root application widget. Wires up providers, theme and named routes.
class DataVaultApp extends StatelessWidget {
  const DataVaultApp({
    super.key,
    required this.storage,
    this.paymentGateway,
  });

  final StorageService storage;
  final PaymentGateway? paymentGateway;

  @override
  Widget build(BuildContext context) {
    final authService = AuthService(storage);
    final apiService = ApiService(storage);
    final notificationService = NotificationService(storage);
    final gateway = paymentGateway ?? MockPaymentGateway();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(
          create: (_) => WalletProvider(
            apiService,
            notificationService: notificationService,
          ),
        ),
        ChangeNotifierProvider(create: (_) => SettingsProvider(storage)),
        Provider<NotificationService>.value(value: notificationService),
        Provider<PaymentGateway>.value(value: gateway),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            routes: {
              '/': (_) => const SplashScreen(),
              '/onboarding': (_) => const OnboardingScreen(),
              '/login': (_) => const LoginScreen(),
              '/signup': (_) => const SignupScreen(),
              '/forgot-password': (_) => const ForgotPasswordScreen(),
              '/home': (_) => const DashboardTab(),
              '/wallet': (_) => const WalletScreen(),
              '/transactions': (_) => const TransactionsScreen(),
              '/notifications': (_) => NotificationsScreen(
                    notificationService: notificationService,
                  ),
              '/search': (_) => const SearchScreen(),
              '/edit-profile': (_) => const EditProfileScreen(),
              '/services/airtime': (_) => const AirtimeScreen(),
              '/services/data': (_) => const DataScreen(),
              '/services/electricity': (_) => const ElectricityScreen(),
              '/services/cable': (_) => const CableTvScreen(),
              '/services/education': (_) => const EducationScreen(),
            },
          );
        },
      ),
    );
  }
}
