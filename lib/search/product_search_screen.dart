import 'package:flutter/material.dart';
import '../data/product.dart';
import '../data/product_repository.dart';
import 'product_search_controller.dart';

// Screen for searching products
class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key, required this.repository});

  final ProductRepository repository;

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  late final ProductSearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = ProductSearchController(repository: widget.repository);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _searchController.updateQuery,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                labelText: 'Search products',
                hintText: 'Type a product name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: _searchController,
              builder: (context, _) => _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  // Build the content of the screen
  Widget _buildContent() {
    switch (_searchController.status) {
      case ProductSearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ProductSearchStatus.empty:
        return const _MessageState(
          icon: Icons.search_off,
          title: 'No products found',
          message: 'Try a different search term.',
        );
      case ProductSearchStatus.error:
        return _MessageState(
          icon: Icons.error_outline,
          title: 'Search failed',
          message: _searchController.errorMessage ?? 'Please try again.',
          action: FilledButton.icon(
            onPressed: _searchController.retry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        );
      case ProductSearchStatus.results:
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: _searchController.products.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final product = _searchController.products[index];
            return _ProductTile(product: product);
          },
        );
    }
  }
}

// Product tile for the screen
class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(product.name),
      trailing: Text(
        '\$${formatPrice(product.priceInMinorUnits)}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

// Message state for the screen
class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
