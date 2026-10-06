import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:product_search/data/product.dart';
import 'package:product_search/data/product_repository.dart';
import 'package:product_search/search/product_search_controller.dart';

void main() {
  group('ProductSearchController', () {
    test('loads all products for the initial empty query', () async {
      final repository = _ControlledRepository();
      final controller = ProductSearchController(repository: repository);

      expect(repository.queries, ['']);
      repository.completeNext([_mouse]);
      await _flushAsyncWork();

      expect(controller.status, ProductSearchStatus.results);
      expect(controller.products, [_mouse]);
      controller.dispose();
    });

    testWidgets('debounces query changes for 400 milliseconds', (tester) async {
      final repository = _ControlledRepository();
      final controller = ProductSearchController(repository: repository);

      controller.updateQuery('m');
      controller.updateQuery('mouse');
      await tester.pump(const Duration(milliseconds: 399));
      expect(repository.queries, ['']);

      await tester.pump(const Duration(milliseconds: 1));
      expect(repository.queries, ['', 'mouse']);
      controller.dispose();
    });

    testWidgets('ignores stale results and stale errors', (tester) async {
      final repository = _ControlledRepository();
      final controller = ProductSearchController(repository: repository);

      controller.updateQuery('mouse');
      await tester.pump(const Duration(milliseconds: 400));
      controller.updateQuery('keyboard');
      await tester.pump(const Duration(milliseconds: 400));

      repository.complete(2, [_keyboard]);
      await tester.pump();
      expect(controller.products, [_keyboard]);

      repository.completeError(0, Exception('old empty-query error'));
      repository.complete(1, [_mouse]);
      await tester.pump();
      expect(controller.status, ProductSearchStatus.results);
      expect(controller.products, [_keyboard]);
      controller.dispose();
    });

    test('retry searches again with the current query', () async {
      final repository = _ControlledRepository();
      final controller = ProductSearchController(repository: repository);

      repository.completeNextError(Exception('network unavailable'));
      await _flushAsyncWork();
      expect(controller.status, ProductSearchStatus.error);

      controller.retry();
      expect(repository.queries, ['', '']);
      repository.completeNext([_mouse]);
      await _flushAsyncWork();

      expect(controller.status, ProductSearchStatus.results);
      controller.dispose();
    });
  });
}

const _mouse = Product(id: 1, name: 'Mouse', priceInMinorUnits: 2499);
const _keyboard = Product(id: 2, name: 'Keyboard', priceInMinorUnits: 8999);

Future<void> _flushAsyncWork() => Future<void>.delayed(Duration.zero);

class _ControlledRepository extends ProductRepository {
  final queries = <String>[];
  final _requests = <Completer<List<Product>>>[];

  @override
  Future<List<Product>> searchProducts(String query) {
    queries.add(query);
    final request = Completer<List<Product>>();
    _requests.add(request);
    return request.future;
  }

  void completeNext(List<Product> products) {
    _requests.firstWhere((request) => !request.isCompleted).complete(products);
  }

  void completeNextError(Object error) {
    _requests
        .firstWhere((request) => !request.isCompleted)
        .completeError(error);
  }

  void complete(int index, List<Product> products) {
    _requests[index].complete(products);
  }

  void completeError(int index, Object error) {
    _requests[index].completeError(error);
  }
}
