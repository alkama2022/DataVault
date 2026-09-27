import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/transaction_model.dart';
import '../../widgets/service_form_scaffold.dart';

/// Data bundle purchase screen.
class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  static const _networks = ['MTN', 'Airtel', 'Glo', '9mobile'];
  static const _plans = [
    'MTN 1GB — ₦350 (30 days)',
    'MTN 2GB — ₦650 (30 days)',
    'MTN 5GB — ₦1,600 (30 days)',
    'Airtel 1.5GB — ₦500 (30 days)',
    'Airtel 3GB — ₦1,000 (30 days)',
    'Glo 2GB — ₦800 (30 days)',
    'Glo 5GB — ₦1,900 (30 days)',
    '9mobile 1GB — ₦450 (30 days)',
  ];

  @override
  Widget build(BuildContext context) {
    return ServiceFormScaffold(
      title: 'Data Subscription',
      icon: Icons.wifi_rounded,
      color: AppColors.data,
      type: TransactionType.data,
      fields: const [
        ServiceField(
          key: 'network',
          label: 'Network',
          hint: 'Select network',
          icon: Icons.signal_cellular_alt_rounded,
          dropdownOptions: _networks,
        ),
        ServiceField(
          key: 'plan',
          label: 'Data Plan',
          hint: 'Select a plan',
          icon: Icons.data_usage_rounded,
          dropdownOptions: _plans,
        ),
        ServiceField(
          key: 'phone',
          label: 'Phone Number',
          hint: '08012345678',
          icon: Icons.phone_rounded,
          keyboardType: TextInputType.phone,
        ),
      ],
      summaryBuilder: (v) => [
        ('Network', v['network'] ?? '-'),
        ('Plan', v['plan'] ?? '-'),
        ('Phone', v['phone'] ?? '-'),
      ],
      validate: (key, value, values) {
        switch (key) {
          case 'network':
            return value.isEmpty ? 'Please select a network' : null;
          case 'plan':
            return value.isEmpty ? 'Please select a data plan' : null;
          case 'phone':
            if (value.trim().length < 10) return 'Enter a valid phone number';
            return null;
        }
        return null;
      },
    );
  }
}
