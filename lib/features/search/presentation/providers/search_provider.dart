import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/search_products.dart';

part 'search_provider.g.dart';

@riverpod
ProductRepositoryImpl productRepository(Ref ref) => ProductRepositoryImpl();

@riverpod
SearchProducts searchProducts(Ref ref) =>
    SearchProducts(ref.watch(productRepositoryProvider));

@riverpod
class SearchController extends _$SearchController {
  int _requestId = 0;

  @override
  FutureOr<List<Product>> build() => [];

  Future<void> search(String query) async {
    final currentId = ++_requestId;
    state = const AsyncLoading();

    final result = await ref.read(searchProductsProvider).call(query);

    if (currentId != _requestId) return;

    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (products) => AsyncData(products),
    );
  }
}
