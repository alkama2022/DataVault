import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/transaction_tile.dart';

/// Transaction history screen with pull-to-refresh and empty state.
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final transactions = wallet.transactions;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.transactions)),
      body: wallet.isLoading && transactions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
              ? EmptyState(
                  icon: Icons.receipt_long_rounded,
                  title: AppStrings.noTransactions,
                  message: AppStrings.noTransactionsHint,
                  actionLabel: AppStrings.retry,
                  onAction: () => wallet.loadDashboard(),
                )
              : RefreshIndicator(
                  onRefresh: () => wallet.loadDashboard(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: transactions.length,
                    itemBuilder: (context, i) =>
                        TransactionTile(transaction: transactions[i]),
                  ),
                ),
    );
  }
}
