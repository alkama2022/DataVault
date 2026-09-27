import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../services/payment_gateway.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Wallet screen: balance overview, fund wallet (via payment gateway) and withdraw.
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isFunding = true;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.trim());
    final wallet = context.read<WalletProvider>();
    wallet.clearError();

    if (_isFunding) {
      await _fundWithGateway(amount);
    } else {
      final success = await wallet.withdraw(amount);
      if (success && mounted) {
        _amountController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Withdrawal of ₦${NumberFormat('#,##0.00').format(amount)} successful'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  /// Funds the wallet through the payment gateway abstraction.
  /// Replace [MockPaymentGateway] with a real implementation (Paystack,
  /// Flutterwave, etc.) in app.dart to go live.
  Future<void> _fundWithGateway(double amount) async {
    final gateway = context.read<PaymentGateway>();
    final auth = context.read<AuthProvider>();
    final wallet = context.read<WalletProvider>();

    final reference = generatePaymentReference();

    // Initialize payment
    final initResult = await gateway.initializePayment(
      amount: amount,
      email: auth.user?.email ?? '',
      reference: reference,
    );

    if (!initResult.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(initResult.error ?? 'Payment initialization failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // In a real app, open initResult.authorizationUrl in a WebView here.
    // For this implementation we verify directly.
    final verifyResult = await gateway.verifyPayment(reference);

    if (!verifyResult.success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment verification failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    final success = await wallet.fundWallet(amount);
    if (success && mounted) {
      _amountController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Wallet funded successfully with ₦${NumberFormat('#,##0.00').format(amount)}'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final balance = NumberFormat('#,##0.00').format(wallet.walletBalance);
    final earnings = NumberFormat('#,##0.00').format(wallet.earnings);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, Color(0xFF1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Available Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₦$balance',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _miniStat('Earnings', '₦$earnings')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _miniStat(
                            'Transactions', '${wallet.transactions.length}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _toggleButton(
                      label: AppStrings.fundWallet,
                      icon: Icons.add_card_rounded,
                      selected: _isFunding,
                      onTap: () => setState(() => _isFunding = true),
                    ),
                  ),
                  Expanded(
                    child: _toggleButton(
                      label: AppStrings.withdraw,
                      icon: Icons.account_balance_rounded,
                      selected: !_isFunding,
                      onTap: () => setState(() => _isFunding = false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Amount (₦)',
                    controller: _amountController,
                    hint: 'Enter amount',
                    prefixIcon: Icons.money_rounded,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Amount is required';
                      final amount = double.tryParse(v.trim());
                      if (amount == null || amount <= 0) return 'Enter a valid amount';
                      if (!_isFunding && amount > wallet.earnings) {
                        return 'Insufficient earnings balance';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if (wallet.error != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              wallet.error!,
                              style: const TextStyle(
                                  color: AppColors.error, fontSize: 13.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  CustomButton(
                    label: _isFunding ? 'Fund Wallet' : 'Withdraw',
                    isLoading: wallet.isProcessing,
                    onPressed: _submit,
                  ),
                  if (_isFunding) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Payment is processed securely via your configured gateway.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: selected ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
