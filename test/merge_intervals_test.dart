import 'package:flutter_test/flutter_test.dart';
import 'package:product_search/intervals/merge_intervals.dart';

void main() {
  test('example from the brief', () {
    expect(
      mergeIntervals([
        [8, 10],
        [1, 3],
        [2, 6],
        [9, 12],
      ]),
      [
        [1, 6],
        [8, 12],
      ],
    );
  });

  test('empty and single inputs', () {
    expect(mergeIntervals([]), isEmpty);
    expect(
      mergeIntervals([
        [4, 5],
      ]),
      [
        [4, 5],
      ],
    );
  });

  test('touching intervals merge', () {
    expect(
      mergeIntervals([
        [3, 5],
        [1, 3],
      ]),
      [
        [1, 5],
      ],
    );
  });

  test('contained interval does not shrink the end', () {
    expect(
      mergeIntervals([
        [1, 10],
        [2, 3],
      ]),
      [
        [1, 10],
      ],
    );
  });

  test('disjoint intervals are only sorted', () {
    expect(
      mergeIntervals([
        [7, 8],
        [1, 2],
        [4, 5],
      ]),
      [
        [1, 2],
        [4, 5],
        [7, 8],
      ],
    );
  });

  test('does not mutate the input', () {
    final input = [
      [2, 6],
      [1, 3],
    ];
    mergeIntervals(input);
    expect(input, [
      [2, 6],
      [1, 3],
    ]);
  });

  test('rejects malformed intervals', () {
    expect(
      () => mergeIntervals([
        [5, 1],
      ]),
      throwsArgumentError,
    );
    expect(
      () => mergeIntervals([
        [1],
      ]),
      throwsArgumentError,
    );
  });
}
