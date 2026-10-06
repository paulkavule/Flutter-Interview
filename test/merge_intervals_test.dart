import 'package:test/test.dart';

import '../bin/merge_intervals.dart';

void main() {
  test('merges overlapping intervals', () {
    final input = [[8, 10], [1, 3], [2, 6], [9, 12]];

    expect(mergeOverlappingIntervals(input), [[1, 6], [8, 12]]);
  });

  test('returns empty list for empty input', () {
    expect(mergeOverlappingIntervals([]), []);
  });
}
