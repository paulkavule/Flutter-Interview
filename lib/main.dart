import 'package:flutter/material.dart';
import 'package:dart_function/registration.dart';
import 'package:dart_function/products.dart';

void main() {
  runApp(const MyApp());
}

/// Represents a booking interval with an integer start and end.
class Interval {
  final int start;
  final int end;

  Interval(this.start, this.end);

  @override
  String toString() => '[$start, $end]';
}

/// Merges overlapping booking intervals and returns a new sorted list.

List<Interval> mergeIntervals(List<Interval> intervals) {
  if (intervals.isEmpty) return [];

  // 1. Sort by start value (tie-break on end value for stability).
  final sorted = List<Interval>.from(intervals)
    ..sort((a, b) {
      final cmp = a.start.compareTo(b.start);
      return cmp != 0 ? cmp : a.end.compareTo(b.end);
    });

  final merged = <Interval>[];
  Interval current = sorted.first;

  // 2. Walk through the sorted list and merge overlapping intervals.
  for (int i = 1; i < sorted.length; i++) {
    final next = sorted[i];

    // Overlap or touch extend the current interval.
    if (next.start <= current.end) {
      final newEnd = next.end > current.end ? next.end : current.end;
      current = Interval(current.start, newEnd);
    } else {
      // No overlap push current and start a new one.
      merged.add(current);
      current = next;
    }
  }

  merged.add(current);
  return merged;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Function',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 4, 64, 114)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dart Function Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Sample input: [[8, 10], [1, 3], [2, 6], [9, 12]]
  // Expected output after merge: [[1, 6], [8, 12]]
  final List<Interval> _bookings = [
    Interval(8, 10),
    Interval(1, 3),
    Interval(2, 6),
    Interval(9, 12),
  ];

  late List<Interval> _merged;

  @override
  void initState() {
    super.initState();
    _merged = mergeIntervals(_bookings);
  }

  void _remerge() {
    setState(() {
      _merged = mergeIntervals(_bookings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home_outlined), text: 'Home'),
              Tab(icon: Icon(Icons.storefront_outlined), text: 'Products'),
              Tab(
                  icon: Icon(Icons.person_add_alt_1_outlined),
                  text: 'Register'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Input (${_bookings.length})',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(_bookings.toString()),
                  const Divider(height: 32),
                  Text('Output (${_merged.length})',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(_merged.toString()),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: _remerge,
                      child: const Text('Re-merge'),
                    ),
                  ),
                ],
              ),
            ),
            const ProductsScreen(),
            const RegistrationScreen(),
          ],
        ),
      ),
    );
  }
}
