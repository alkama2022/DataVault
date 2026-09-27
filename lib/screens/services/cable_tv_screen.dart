import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/transaction_model.dart';
import '../../widgets/service_form_scaffold.dart';

/// Cable TV subscription screen.
class CableTvScreen extends StatelessWidget {
  const CableTvScreen({super.key});

  static const _providers = ['DSTV', 'GOtv', 'Startimes'];
  static const _packages = [
    'DSTV Premium — ₦24,500/mo',
    'DSTV Compact — ₦16,600/mo',
    'DSTV Confam — ₦10,500/mo',
    'GOtv Max — ₦7,200/mo',
    'GOtv Jolli — ₦4,850/mo',
    'Startimes Super — ₦6,500/mo',
  ];

  @override
  Widget build(BuildContext context) {
    return ServiceFormScaffold(
      title: 'Cable Subscription',
      icon: Icons.tv_rounded,
      color: AppColors.cable,
      type: TransactionType.cable,
      fields: const [
        ServiceField(
          key: 'provider',
          label: 'Provider',
          hint: 'Select provider',
          icon: Icons.live_tv_rounded,
          dropdownOptions: _providers,
        ),
        ServiceField(
          key: 'package',
          label: 'Package',
          hint: 'Select package',
          icon: Icons.card_membership_rounded,
          dropdownOptions: _packages,
        ),
        ServiceField(
          key: 'smartcard',
          label: 'Smart Card Number',
          hint: 'Enter smart card number',
          icon: Icons.credit_card_rounded,
          keyboardType: TextInputType.number,
        ),
      ],
      summaryBuilder: (v) => [
        ('Provider', v['provider'] ?? '-'),
        ('Package', v['package'] ?? '-'),
        ('Smart Card', v['smartcard'] ?? '-'),
      ],
      validate: (key, value, values) {
        switch (key) {
          case 'provider':
            return value.isEmpty ? 'Please select a provider' : null;
          case 'package':
            return value.isEmpty ? 'Please select a package' : null;
          case 'smartcard':
            if (value.trim().length < 8) return 'Enter a valid smart card number';
            return null;
        }
        return null;
      },
    );
  }
}
