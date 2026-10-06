List<List<int>> mergeIntervals(List<List<int>> intervals) {
  if (intervals.isEmpty) return [];

  // sort list by starting interval
  final sorted = List<List<int>>.from(intervals)
    ..sort((a, b) => a[0].compareTo(b[0]));

  final result = <List<int>>[];
  var current = [...sorted.first];

  for (var i = 1; i < sorted.length; i++) {
    final next = sorted[i];

    if (next[0] <= current[1]) {
      if (next[1] > current[1]) current[1] = next[1];
    } else {
      result.add(current);
      current = [...next];
    }
  }

  result.add(current);
  return result;
}

void main() {
  final bookings = [
    [8, 10],
    [1, 3],
    [2, 6],
    [9, 12],
  ];

  print(mergeIntervals(bookings));
}