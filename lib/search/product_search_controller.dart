import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/product.dart';
import '../data/product_repository.dart';

abstract class ProductSearchState {
  const ProductSearchState(this.query);

  final String query;
}

class ProductSearchLoading extends ProductSearchState {
  const ProductSearchLoading(super.query);
}

class ProductSearchSuccess extends ProductSearchState {
  const ProductSearchSuccess(super.query, this.products);

  final List<Product> products;
}

class ProductSearchError extends ProductSearchState {
  const ProductSearchError(super.query, this.message);

  final String message;
}

final productSearchControllerProvider =
    NotifierProvider.family<
      ProductSearchController,
      ProductSearchState,
      ProductRepository
    >(ProductSearchController.new);

class ProductSearchController
    extends FamilyNotifier<ProductSearchState, ProductRepository> {
  Timer? _timer;
  int _requestId = 0;
  bool _disposed = false;

  @override
  ProductSearchState build(ProductRepository repository) {
    ref.onDispose(() {
      _disposed = true;
      _timer?.cancel();
    });

    Future.microtask(() {
      if (!_disposed) {
        _search('');
      }
    });

    return const ProductSearchLoading('');
  }

  void onQueryChanged(String query) {
    _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    final requestId = ++_requestId;

    state = ProductSearchLoading(query);

    try {
      final products = await arg.searchProducts(query);

      if (_disposed || requestId != _requestId) {
        return;
      }

      state = ProductSearchSuccess(query, products);
    } catch (e) {
      if (_disposed || requestId != _requestId) {
        return;
      }

      state = ProductSearchError(query, e.toString());
    }
  }

  void retry() {
    _search(state.query);
  }
}
