import 'package:flutter/foundation.dart';

import '../data/product.dart';

enum SearchStatus { loading, success, failure }

@immutable
class ProductSearchState {
  const ProductSearchState._({
    required this.query,
    required this.status,
    this.products,
    this.error,
  });

  const ProductSearchState.initial()
    : this._(query: '', status: SearchStatus.loading);

  ProductSearchState.success(String query, List<Product> products)
    : this._(
        query: query,
        status: SearchStatus.success,
        products: List.unmodifiable(products),
      );

  const ProductSearchState.failure(String query, Object error)
    : this._(query: query, status: SearchStatus.failure, error: error);

  final String query;
  final SearchStatus status;
  final List<Product>? products;
  final Object? error;

  bool get isLoading => status == SearchStatus.loading;

  ProductSearchState loading(String newQuery) => ProductSearchState._(
    query: newQuery,
    status: SearchStatus.loading,
    products: products,
  );
}
