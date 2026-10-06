
import 'dart:convert';
import 'dart:io';

void main() {
  print('Enter intervals as JSON, e.g. [[8,10],[1,3],[2,6]]');
  print('Press Enter on an empty line (or Ctrl+D) to quit.\n');

  while (true) {
    stdout.write('> ');
    final line = stdin.readLineSync();
    if (line == null || line.trim().isEmpty) break;

    try {
      final input = parseIntervals(line);
      print('Input:  $input');
      print('Output: ${mergeOverlappingIntervals(input)}\n');
    } on FormatException catch (e) {
      print('Invalid input: ${e.message}\n');
    }
  }
}

List<List<int>> parseIntervals(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is! List) {
    throw const FormatException('Expected a list of intervals');
  }

  return decoded.map<List<int>>((item) {
    if (item is! List || item.length != 2 || item.any((n) => n is! int)) {
      throw FormatException('Each interval must be [start, end], got $item');
    }
    final start = item[0] as int;
    final end = item[1] as int;
    if (start > end) {
      throw FormatException('Start must be <= end, got $item');
    }
    return [start, end];
  }).toList();
}

List<List<int>> mergeOverlappingIntervals(List<List<int>> intervals) {
  // Return empty list if intervals is empty
  if (intervals.isEmpty) return [];

  // Sort intervals by start time
  final sorted = [...intervals]..sort((a, b) => a[0].compareTo(b[0]));

  // Initialize merged list with first interval
  final merged = <List<int>>[
    [sorted.first[0], sorted.first[1]],
  ];

  // Iterate through remaining intervals
  for (final current in sorted.skip(1)) {
    final last = merged.last;

    if (current[0] <= last[1]) {
      if (current[1] > last[1]) last[1] = current[1];
    } else {
      merged.add([current[0], current[1]]);
    }
  }

  return merged;
}