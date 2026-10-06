import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_repository.dart';
import '../data/product_repository_adapter.dart';
import '../domain/usecases/search_products.dart';
import '../presentation/bloc/product_search_bloc.dart';
import '../presentation/bloc/product_search_event.dart';
import '../presentation/bloc/product_search_state.dart';
import '../presentation/widgets/product_empty_view.dart';
import '../presentation/widgets/product_error_view.dart';
import '../presentation/widgets/product_list_tile.dart';
import '../presentation/widgets/product_loading_view.dart';
import '../presentation/widgets/product_search_bar.dart';

class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({
    super.key,
    required this.repository,
  });

  final ProductRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductSearchBloc(
        searchProducts: SearchProducts(
          ProductRepositoryAdapter(repository),
        ),
      )..add(const ProductSearchStarted()),
      child: const _ProductSearchView(),
    );
  }
}

class _ProductSearchView extends StatefulWidget {
  const _ProductSearchView();

  @override
  State<_ProductSearchView> createState() => _ProductSearchViewState();
}

class _ProductSearchViewState extends State<_ProductSearchView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: ProductSearchBar(
                controller: _searchController,
                onChanged: (query) {
                  context.read<ProductSearchBloc>().add(
                        ProductSearchQueryChanged(query),
                      );
                },
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<ProductSearchBloc, ProductSearchState>(
                builder: (context, state) {
                  return switch (state) {
                    ProductSearchInitial() => const SizedBox.shrink(),
                    ProductSearchLoading() => const ProductLoadingView(),
                    ProductSearchEmpty(:final query) => ProductEmptyView(
                        query: query,
                      ),
                    ProductSearchFailure(:final message) => ProductErrorView(
                        message: message,
                        onRetry: () {
                          context.read<ProductSearchBloc>().add(
                                const ProductSearchRetryRequested(),
                              );
                        },
                      ),
                    ProductSearchSuccess(:final products) => ListView.separated(
                        itemCount: products.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        itemBuilder: (context, index) {
                          return ProductListTile(product: products[index]);
                        },
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
