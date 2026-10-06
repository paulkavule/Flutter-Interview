// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productRepository)
final productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepositoryImpl,
          ProductRepositoryImpl,
          ProductRepositoryImpl
        >
    with $Provider<ProductRepositoryImpl> {
  ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepositoryImpl create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepositoryImpl>(value),
    );
  }
}

String _$productRepositoryHash() => r'd8e57c1b1a0f7a1afe26dd4c556203615a5125eb';

@ProviderFor(searchProducts)
final searchProductsProvider = SearchProductsProvider._();

final class SearchProductsProvider
    extends $FunctionalProvider<SearchProducts, SearchProducts, SearchProducts>
    with $Provider<SearchProducts> {
  SearchProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchProductsHash();

  @$internal
  @override
  $ProviderElement<SearchProducts> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SearchProducts create(Ref ref) {
    return searchProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchProducts value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchProducts>(value),
    );
  }
}

String _$searchProductsHash() => r'530dc1f56c6edbb79e38ad62ce495ccc54e13645';

@ProviderFor(SearchController)
final searchControllerProvider = SearchControllerProvider._();

final class SearchControllerProvider
    extends $AsyncNotifierProvider<SearchController, List<Product>> {
  SearchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchControllerHash();

  @$internal
  @override
  SearchController create() => SearchController();
}

String _$searchControllerHash() => r'c1f2cb30a7b3c8f873fc407b8ebcd8d81b296763';

abstract class _$SearchController extends $AsyncNotifier<List<Product>> {
  FutureOr<List<Product>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
              AsyncValue<List<Product>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
