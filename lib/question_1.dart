void main() {
  final input = [
    [8, 10],
    [1, 3],
    [2, 6],
    [9, 12],
  ];

  print('Input: $input');
  print('Output: ${mergeIntervals(input)}');
}

List<List<int>> mergeIntervals(List<List<int>> intervals) {
  if (intervals.isEmpty) return [];
  intervals.sort((a, b) => a[0].compareTo(b[0]));
  final List<List<int>> merged = [intervals[0]];
  for (int i = 1; i < intervals.length; i++) {
    final current = intervals[i];
    final lastMerged = merged.last;
    if (current[0] <= lastMerged[1]) {
      lastMerged[1] = current[1] > lastMerged[1] ? current[1] : lastMerged[1];
    } else {
      merged.add(current);
    }
  }
  return merged;
}
