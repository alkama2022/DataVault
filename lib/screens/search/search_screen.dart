import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/service_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/service_grid_item.dart';
import '../../widgets/transaction_tile.dart';

/// Search screen: search across services and transaction history.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final q = _query.trim().toLowerCase();

    final filteredServices = q.isEmpty
        ? <ServiceModel>[]
        : ServiceCatalog.all
            .where((s) =>
                s.name.toLowerCase().contains(q) ||
                s.description.toLowerCase().contains(q))
            .toList();

    final filteredTransactions = q.isEmpty
        ? <TransactionModel>[]
        : wallet.transactions
            .where((t) =>
                t.description.toLowerCase().contains(q) ||
                t.typeLabel.toLowerCase().contains(q) ||
                (t.reference?.toLowerCase().contains(q) ?? false))
            .toList();

    final hasResults = filteredServices.isNotEmpty || filteredTransactions.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search services, transactions...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Results
          Expanded(
            child: _query.isEmpty
                ? _buildRecentTransactions(wallet)
                : !hasResults
                    ? EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'No results found',
                        message: 'Try a different search term.',
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          if (filteredServices.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 4),
                              child: Text(
                                'Services',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.95,
                              children: filteredServices
                                  .map((s) => ServiceGridItem(
                                        service: s,
                                        onTap: () =>
                                            Navigator.pushNamed(context, s.route),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                          ],
                          if (filteredTransactions.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10, left: 4),
                              child: Text(
                                'Transactions',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            ...filteredTransactions
                                .map((t) => TransactionTile(transaction: t)),
                          ],
                          const SizedBox(height: 20),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(WalletProvider wallet) {
    final recent = wallet.transactions.take(5).toList();
    if (recent.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'No recent transactions',
        message: 'Your recent transactions will appear here.',
      );
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10, left: 4),
          child: Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...recent.map((t) => TransactionTile(transaction: t)),
      ],
    );
  }
}
