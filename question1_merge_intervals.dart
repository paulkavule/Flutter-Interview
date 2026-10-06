/// Merges overlapping [start, end] booking intervals into a sorted list.
List<List<int>> mergeOverlappingIntervals(List<List<int>> intervals) {
  if (intervals.isEmpty) return [];

  final sorted = List<List<int>>.from(intervals);
  sorted.sort((a, b) => a[0].compareTo(b[0]));

  final merged = <List<int>>[
    [sorted.first[0], sorted.first[1]],
  ];

  for (final interval in sorted.skip(1)) {
    final last = merged.last;
    if (interval[0] <= last[1]) {
      last[1] = interval[1] > last[1] ? interval[1] : last[1];
    } else {
      merged.add([interval[0], interval[1]]);
    }
  }

  return merged;
}

void main() {
  const input = [
    [8, 10],
    [1, 3],
    [2, 6],
    [9, 12],
  ];
  print(mergeOverlappingIntervals(input));
}
