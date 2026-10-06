import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.isNotEmpty) {
        ref.read(searchControllerProvider.notifier).search(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Products')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: state.when(
              data: (products) => products.isEmpty
                  ? const Center(child: Text('No products found'))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final p = products[index];
                        return ListTile(
                          title: Text(p.name),
                          subtitle: Text(
                            '\$${(p.priceInMinorUnits / 100).toStringAsFixed(2)}',
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
