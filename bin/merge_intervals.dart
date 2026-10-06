
void main() {
  final cases = <List<List<int>>>[
    [[8, 10], [1, 3], [2, 6], [9, 12]],
    [],
    [[1, 4]],
    [[1, 10], [2, 5]],
    [[1, 3], [3, 5]],
    [[5, 6], [1, 2]],
  ];

  for (final input in cases) {
    print('Input:  $input');
    print('Output: ${mergeOverlappingIntervals(input)}');
    print('');
  }
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