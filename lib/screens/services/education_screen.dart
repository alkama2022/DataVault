import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/transaction_model.dart';
import '../../widgets/service_form_scaffold.dart';

/// Education payment screen (WAEC, NABTEB, JAMB scratch cards).
class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  static const _services = [
    'WAEC Scratch Card — ₦4,500',
    'NABTEB Scratch Card — ₦2,500',
    'JAMB UTME Pin — ₦3,500',
    'Post-UTME Pin — ₦2,000',
  ];

  @override
  Widget build(BuildContext context) {
    return ServiceFormScaffold(
      title: 'Education Payment',
      icon: Icons.school_rounded,
      color: AppColors.education,
      type: TransactionType.education,
      fields: const [
        ServiceField(
          key: 'service',
          label: 'Service',
          hint: 'Select service',
          icon: Icons.menu_book_rounded,
          dropdownOptions: _services,
        ),
        ServiceField(
          key: 'email',
          label: 'Email Address',
          hint: 'Result will be sent here',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        ServiceField(
          key: 'quantity',
          label: 'Quantity',
          hint: 'Number of cards',
          icon: Icons.format_list_numbered_rounded,
          keyboardType: TextInputType.number,
        ),
      ],
      summaryBuilder: (v) => [
        ('Service', v['service'] ?? '-'),
        ('Email', v['email'] ?? '-'),
        ('Quantity', v['quantity'] ?? '1'),
      ],
      validate: (key, value, values) {
        switch (key) {
          case 'service':
            return value.isEmpty ? 'Please select a service' : null;
          case 'email':
            if (value.trim().isEmpty) return 'Email is required';
            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
              return 'Enter a valid email address';
            }
            return null;
          case 'quantity':
            final qty = int.tryParse(value.trim());
            if (qty == null || qty <= 0) return 'Enter a valid quantity';
            if (qty > 5) return 'Maximum 5 cards per transaction';
            return null;
        }
        return null;
      },
    );
  }
}
