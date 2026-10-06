import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_products.dart';
import 'product_search_event.dart';
import 'product_search_state.dart';

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  ProductSearchBloc({required SearchProducts searchProducts})
    : _searchProducts = searchProducts,
      super(const ProductSearchInitial()) {
    on<ProductSearchStarted>(_onStarted);
    on<ProductSearchQueryChanged>(_onQueryChanged);
    on<ProductSearchRetryRequested>(_onRetryRequested);
    on<ProductSearchExecutionRequested>(_onExecutionRequested);
  }

  final SearchProducts _searchProducts;

  Timer? _debounceTimer;
  int _activeRequestId = 0;
  String _currentQuery = '';

  void _onStarted(
    ProductSearchStarted event,
    Emitter<ProductSearchState> emit,
  ) {
    _debounceTimer?.cancel();
    add(const ProductSearchExecutionRequested(''));
  }

  void _onQueryChanged(
    ProductSearchQueryChanged event,
    Emitter<ProductSearchState> emit,
  ) {
    _currentQuery = event.query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      add(ProductSearchExecutionRequested(event.query));
    });
  }

  void _onRetryRequested(
    ProductSearchRetryRequested event,
    Emitter<ProductSearchState> emit,
  ) {
    _debounceTimer?.cancel();
    add(ProductSearchExecutionRequested(_currentQuery));
  }

  Future<void> _onExecutionRequested(
    ProductSearchExecutionRequested event,
    Emitter<ProductSearchState> emit,
  ) async {
    final requestId = ++_activeRequestId;
    _currentQuery = event.query;

    emit(ProductSearchLoading(event.query));

    try {
      final products = await _searchProducts(event.query);

      if (requestId != _activeRequestId || emit.isDone) {
        return;
      }

      if (products.isEmpty) {
        emit(ProductSearchEmpty(event.query));
      } else {
        emit(ProductSearchSuccess(products: products, query: event.query));
      }
    } catch (error) {
      if (requestId != _activeRequestId || emit.isDone) {
        return;
      }

      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : 'An unexpected error occurred';

      emit(ProductSearchFailure(message: message, query: event.query));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
