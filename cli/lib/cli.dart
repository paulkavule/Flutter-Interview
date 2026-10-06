int calculate() {
  return 6 * 7;
}

List<List<int>> mergeIntervals(List<List<int>> intervals) {
  intervals.sort((a, b) => a[0].compareTo(b[0]));

  print(intervals);

  List<List<int>> result = [];

  for (var interval in intervals) {
    if (result.isEmpty || result.last[1] < interval[0]) {
      result.add(interval);
      print(interval);
    } else {
      result.last[1] = interval[1] > result.last[1]
          ? interval[1]
          : result.last[1];
      print(result);
    }
  }

  return result;
}
