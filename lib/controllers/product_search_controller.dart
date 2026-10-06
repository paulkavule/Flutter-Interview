import 'package:flutter/foundation.dart';

import '../data/product.dart';
import '../data/product_repository.dart';

enum ProductSearchStatus { loading, results, empty, error }

class ProductSearchController extends ChangeNotifier {
  ProductSearchController({required this.repository}) {
    _load(query, ++_requestId);
  }

  final ProductRepository repository;
  int _requestId = 0;

  String query = '';
  List<Product> products = const [];
  ProductSearchStatus status = ProductSearchStatus.loading;

  void setQuery(String value) {
    query = value;
    final requestId = ++_requestId;
    products = const [];
    status = ProductSearchStatus.loading;
    notifyListeners();
    _load(value, requestId);
  }

  void retry() {
    final requestId = ++_requestId;
    products = const [];
    status = ProductSearchStatus.loading;
    notifyListeners();
    _load(query, requestId);
  }

  Future<void> _load(String value, int requestId) async {
    try {
      final results = await repository.searchProducts(value);
      if (requestId != _requestId) return;
      products = results;
      status = results.isEmpty
          ? ProductSearchStatus.empty
          : ProductSearchStatus.results;
    } catch (_) {
      if (requestId != _requestId) return;
      status = ProductSearchStatus.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _requestId++;
    super.dispose();
  }
}