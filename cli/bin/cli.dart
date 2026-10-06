import 'package:cli/cli.dart' as cli;

void main() {
  var bookings = [
    [8, 10],
    [1, 3],
    [2, 6],
    [9, 12],
  ];

  print(cli.mergeIntervals(bookings));
}
