List<List<int>> customSorter(List<List<int>> params) {
  params.sort((a, b) => a[0] - b[0]);

  List<List<int>> value = [];

  for (var index in params) {
    if (index[0] > value.last[1]) {
      value.add(index);
    } else {
      if (index[1] > value.last[1]) {
        value.last[1] = index[1];
      }
      value.last[1] = value.last[1];
    }
  }

  return value;
}
