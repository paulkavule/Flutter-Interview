import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/product.dart';
import '../data/product_repository.dart';

enum ProductSearchStatus { loading, results, empty, error }

class ProductSearchController extends ChangeNotifier {
  ProductSearchController({
    required ProductRepository repository,
    this.debounceDuration = const Duration(milliseconds: 400),
  }) : _repository = repository {
    _runSearch();
  }

  final ProductRepository _repository;
  final Duration debounceDuration;

  Timer? _debounce;
  int _requestVersion = 0;
  String _query = '';
  List<Product> _products = const [];
  ProductSearchStatus _status = ProductSearchStatus.loading;
  String? _errorMessage;
  bool _disposed = false;

  String get query => _query;
  List<Product> get products => _products;
  ProductSearchStatus get status => _status;
  String? get errorMessage => _errorMessage;

  void updateQuery(String value) {
    if (value == _query) return;

    _query = value;
    _debounce?.cancel();
    _requestVersion++;
    _status = ProductSearchStatus.loading;
    _errorMessage = null;
    notifyListeners();

    _debounce = Timer(debounceDuration, _runSearch);
  }

  void retry() {
    _debounce?.cancel();
    _requestVersion++;
    _runSearch();
  }

  Future<void> _runSearch() async {
    final version = ++_requestVersion;
    final searchedQuery = _query;

    _status = ProductSearchStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final products = await _repository.searchProducts(searchedQuery);
      if (_disposed || version != _requestVersion) return;

      _products = List.unmodifiable(products);
      _status = products.isEmpty
          ? ProductSearchStatus.empty
          : ProductSearchStatus.results;
    } catch (error) {
      if (_disposed || version != _requestVersion) return;

      _products = const [];
      _status = ProductSearchStatus.error;
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _requestVersion++;
    _debounce?.cancel();
    super.dispose();
  }
}
