import 'package:flutter/material.dart';

/// A billable service offered in the app grid.
class ServiceModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String route;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}

/// Catalog of services shown on the dashboard.
class ServiceCatalog {
  ServiceCatalog._();

  static const List<ServiceModel> all = [
    ServiceModel(
      id: 'airtime',
      name: 'Airtime Topup',
      description: 'Instant airtime for all networks',
      icon: Icons.phone_android_rounded,
      color: Color(0xFF3B82F6),
      route: '/services/airtime',
    ),
    ServiceModel(
      id: 'data',
      name: 'Data Subscription',
      description: 'Affordable data bundles',
      icon: Icons.wifi_rounded,
      color: Color(0xFF10B981),
      route: '/services/data',
    ),
    ServiceModel(
      id: 'electricity',
      name: 'Electricity Payment',
      description: 'Pay your power bills',
      icon: Icons.bolt_rounded,
      color: Color(0xFFF59E0B),
      route: '/services/electricity',
    ),
    ServiceModel(
      id: 'cable',
      name: 'Cable Subscription',
      description: 'DSTV, GOtv, Startimes',
      icon: Icons.tv_rounded,
      color: Color(0xFF8B5CF6),
      route: '/services/cable',
    ),
    ServiceModel(
      id: 'education',
      name: 'Education Payment',
      description: 'WAEC, NABTEB, JAMB cards',
      icon: Icons.school_rounded,
      color: Color(0xFFEC4899),
      route: '/services/education',
    ),
    ServiceModel(
      id: 'wallet',
      name: 'Fund Wallet',
      description: 'Add money to your wallet',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF06B6D4),
      route: '/wallet',
    ),
    ServiceModel(
      id: 'payment_history',
      name: 'Payment History',
      description: 'View all payments',
      icon: Icons.receipt_long_rounded,
      color: Color(0xFF64748B),
      route: '/transactions',
    ),
    ServiceModel(
      id: 'transaction_history',
      name: 'Transaction History',
      description: 'Full activity log',
      icon: Icons.history_rounded,
      color: Color(0xFF0EA5E9),
      route: '/transactions',
    ),
  ];
}
