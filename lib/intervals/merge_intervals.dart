List<List<int>> mergeIntervals(List<List<int>> intervals) {
  if (intervals.isEmpty) return [];

  for (final interval in intervals) {
    if (interval.length != 2 || interval[0] > interval[1]) {
      throw ArgumentError('Invalid interval: $interval');
    }
  }

  intervals.sort((a, b) => a[0].compareTo(b[0]));

  final result = <List<int>>[List.from(intervals[0])];

  return result;
}
