import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/product_repository.dart';
import 'product_search_state.dart';

class ProductSearchController extends GetxController {
  ProductSearchController({
    required ProductRepository repository,
    this.debounceDuration = const Duration(milliseconds: 400),
  }) : _repository = repository;

  final ProductRepository _repository;
  final Duration debounceDuration;

  final state = const ProductSearchState.initial().obs;
  final textController = TextEditingController();

  Timer? _debounce;
  int _requestId = 0;
  String _latestQuery = '';

  @override
  void onInit() {
    super.onInit();
    _search('');
  }

  void onQueryChanged(String raw) {
    final query = raw.trim();
    if (query == _latestQuery) return;
    _latestQuery = query;
    _debounce?.cancel();
    _debounce = Timer(debounceDuration, () => _search(query));
  }

  void clear() {
    textController.clear();
    onQueryChanged('');
  }

  void retry() {
    _debounce?.cancel();
    _search(state.value.query);
  }

  Future<void> _search(String query) async {
    if (isClosed) return;
    _latestQuery = query;
    final id = ++_requestId;
    state.value = state.value.loading(query);
    try {
      final products = await _repository.searchProducts(query);
      if (id != _requestId || isClosed) return;
      state.value = ProductSearchState.success(query, products);
    } catch (error) {
      if (id != _requestId || isClosed) return;
      state.value = ProductSearchState.failure(query, error);
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    textController.dispose();
    super.onClose();
  }
}
