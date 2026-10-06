
List<List<int>> mergeIntervals(List<List<int>> intervals) {
  for (final interval in intervals) {
    if (interval.length != 2 || interval[0] > interval[1]) {
      throw ArgumentError.value(
        interval,
        'intervals',
        'Interval must be [start, end] with start <= end',
      );
    }
  }



  final sorted = [...intervals]..sort((a, b) => a[0].compareTo(b[0]));
  final merged = <List<int>>[];
  for (final [start, end] in sorted) {
    if (merged.isNotEmpty && start <= merged.last[1]) {
      if (end > merged.last[1]) merged.last[1] = end;
    } else {
      merged.add([start, end]); 
    }
  }

  return merged;
}
