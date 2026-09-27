import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_strings.dart';
import '../models/transaction_model.dart';
import '../providers/wallet_provider.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

/// Shared scaffold for all service purchase screens (airtime, data, etc.).
/// Provides a consistent form layout, validation, confirmation dialog
/// and success state — so each service screen only supplies its fields.
class ServiceFormScaffold extends StatefulWidget {
  const ServiceFormScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.type,
    required this.fields,
    required this.summaryBuilder,
    required this.validate,
  });

  final String title;
  final IconData icon;
  final Color color;
  final TransactionType type;

  /// Form field descriptors rendered in order.
  final List<ServiceField> fields;

  /// Builds the confirmation summary lines from current input values.
  final List<(String, String)> SummaryBuilder(Map<String, String> values);

  /// Returns an error string for [fieldKey] or null when valid.
  final String? Function(String fieldKey, String value, Map<String, String> values)
      validate;

  @override
  State<ServiceFormScaffold> createState() => _ServiceFormScaffoldState();
}

/// Descriptor for a single form field.
class ServiceField {
  const ServiceField({
    required this.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.dropdownOptions,
  });

  final String key;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  /// When non-null, renders a dropdown instead of a text field.
  final List<String>? dropdownOptions;
}

class _ServiceFormScaffoldState extends State<ServiceFormScaffold> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _values = {};
  bool _showSuccess = false;
  TransactionModel? _completedTxn;

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      _controllers[f.key] = TextEditingController();
      _values[f.key] = '';
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = _resolveAmount();
    final wallet = context.read<WalletProvider>();

    // Confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm ${widget.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.summaryBuilder(_values).map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.$1,
                        style: const TextStyle(color: AppColors.textSecondary)),
                    Text(entry.$2,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                Text('₦${NumberFormat('#,##0.00').format(amount)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: AppColors.primary)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    wallet.clearError();
    final txn = await wallet.purchase(
      type: widget.type,
      description: widget.title,
      amount: amount,
    );

    if (!mounted) return;
    if (txn != null) {
      setState(() {
        _showSuccess = true;
        _completedTxn = txn;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(wallet.error ?? 'Transaction failed. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Amount is taken from a field named 'amount' when present.
  double _resolveAmount() {
    final raw = _values['amount'] ?? '0';
    return double.tryParse(raw) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) return _buildSuccess();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Fill in the details below to continue',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Fields
              ...widget.fields.map((f) {
                final controller = _controllers[f.key]!;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: f.dropdownOptions != null
                      ? _buildDropdown(f, controller)
                      : CustomTextField(
                          label: f.label,
                          controller: controller,
                          hint: f.hint,
                          prefixIcon: f.icon,
                          keyboardType: f.keyboardType,
                          onChanged: (v) => _values[f.key] = v,
                          validator: (v) =>
                              widget.validate(f.key, v ?? '', _values),
                        ),
                );
              }),

              const SizedBox(height: 8),
              CustomButton(
                label: 'Continue',
                isLoading: context.watch<WalletProvider>().isProcessing,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(ServiceField f, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          f.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _values[f.key]!.isEmpty ? null : _values[f.key],
          hint: Text(f.hint),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.arrow_drop_down_circle_outlined),
          ),
          items: f.dropdownOptions!
              .map((o) => DropdownMenuItem(value: o, child: Text(o)))
              .toList(),
          onChanged: (v) {
            setState(() {
              _values[f.key] = v ?? '';
              controller.text = v ?? '';
            });
          },
          validator: (v) =>
              widget.validate(f.key, v ?? '', _values),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.success, size: 44),
                ),
                const SizedBox(height: 24),
                const Text(
                  AppStrings.success,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.title} completed successfully.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14.5, color: AppColors.textSecondary),
                ),
                if (_completedTxn != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _row('Amount',
                            '₦${NumberFormat('#,##0.00').format(_completedTxn!.amount)}'),
                        const SizedBox(height: 8),
                        _row('Reference', _completedTxn!.reference ?? '-'),
                        const SizedBox(height: 8),
                        _row('Date',
                            DateFormat('MMM d, yyyy • h:mm a').format(_completedTxn!.date)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                CustomButton(
                  label: 'Done',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
