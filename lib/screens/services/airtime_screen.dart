import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/transaction_model.dart';
import '../../widgets/service_form_scaffold.dart';

/// Airtime top-up purchase screen.
class AirtimeScreen extends StatelessWidget {
  const AirtimeScreen({super.key});

  static const _networks = ['MTN', 'Airtel', 'Glo', '9mobile'];

  @override
  Widget build(BuildContext context) {
    return ServiceFormScaffold(
      title: 'Airtime Topup',
      icon: Icons.phone_android_rounded,
      color: AppColors.airtime,
      type: TransactionType.airtime,
      fields: const [
        ServiceField(
          key: 'network',
          label: 'Network',
          hint: 'Select network',
          icon: Icons.signal_cellular_alt_rounded,
          dropdownOptions: _networks,
        ),
        ServiceField(
          key: 'phone',
          label: 'Phone Number',
          hint: '08012345678',
          icon: Icons.phone_rounded,
          keyboardType: TextInputType.phone,
        ),
        ServiceField(
          key: 'amount',
          label: 'Amount (₦)',
          hint: 'Enter amount',
          icon: Icons.money_rounded,
          keyboardType: TextInputType.number,
        ),
      ],
      summaryBuilder: (v) => [
        ('Network', v['network'] ?? '-'),
        ('Phone', v['phone'] ?? '-'),
        ('Amount', '₦${v['amount'] ?? '0'}'),
      ],
      validate: (key, value, values) {
        switch (key) {
          case 'network':
            return value.isEmpty ? 'Please select a network' : null;
          case 'phone':
            if (value.trim().length < 10) return 'Enter a valid phone number';
            return null;
          case 'amount':
            final amount = double.tryParse(value.trim());
            if (amount == null || amount <= 0) return 'Enter a valid amount';
            if (amount < 50) return 'Minimum airtime amount is ₦50';
            return null;
        }
        return null;
      },
    );
  }
}
