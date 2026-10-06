List<List> mergeIntervals(List<List> intervals) {
  if (intervals.isEmpty) return [];

  final n = intervals.length;
  final starts = List.generate(n, (i) => intervals[i][0])..sort();
  final ends = List.generate(n, (i) => intervals[i][1])..sort();

  final merged = <List>[];
  var startIndex = 0;

  for (var i = 0; i < n; i++) {
    if (i == n - 1 || starts[i + 1] > ends[i]) {
      merged.add([starts[startIndex], ends[i]]);
      startIndex = i + 1;
    }
  }

  return merged;
}

void main() {
  final input = [
    [8, 10],
    [1, 3],
    [2, 6],
    [9, 12],
  ];
  print(mergeIntervals(input));
}
