import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/transaction_model.dart';
import '../../widgets/service_form_scaffold.dart';

/// Electricity bill payment screen.
class ElectricityScreen extends StatelessWidget {
  const ElectricityScreen({super.key});

  static const _discos = [
    'Ikeja Electric',
    'Eko Electric',
    'Kaduna Electric',
    'Abuja Electric',
    'Port Harcourt Electric',
    'Enugu Electric',
  ];

  @override
  Widget build(BuildContext context) {
    return ServiceFormScaffold(
      title: 'Electricity Payment',
      icon: Icons.bolt_rounded,
      color: AppColors.electricity,
      type: TransactionType.electricity,
      fields: const [
        ServiceField(
          key: 'disco',
          label: 'Distribution Company',
          hint: 'Select your disco',
          icon: Icons.electrical_services_rounded,
          dropdownOptions: _discos,
        ),
        ServiceField(
          key: 'meter',
          label: 'Meter Number',
          hint: 'Enter meter number',
          icon: Icons.numbers_rounded,
          keyboardType: TextInputType.number,
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
        ('Disco', v['disco'] ?? '-'),
        ('Meter No.', v['meter'] ?? '-'),
        ('Amount', '₦${v['amount'] ?? '0'}'),
      ],
      validate: (key, value, values) {
        switch (key) {
          case 'disco':
            return value.isEmpty ? 'Please select your disco' : null;
          case 'meter':
            if (value.trim().length < 5) return 'Enter a valid meter number';
            return null;
          case 'amount':
            final amount = double.tryParse(value.trim());
            if (amount == null || amount <= 0) return 'Enter a valid amount';
            if (amount < 500) return 'Minimum amount is ₦500';
            return null;
        }
        return null;
      },
    );
  }
}
