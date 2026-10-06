List<List<int>> mergeBookingIntervals(List<List<int>> intervalList) {
  
  if (intervalList.isEmpty) return [];

  intervalList.sort((a, b) => a[0].compareTo(b[0]));

  List<List<int>> mergedList = [intervalList[0]];

  for (int i = 1; i < intervalList.length; i++) {
    List<int> currentList = intervalList[i];
    List<int> lastMerged = mergedList.last;

    if (currentList[0] <= lastMerged[1]) {
      lastMerged[1] = currentList[1] > lastMerged[1] ? currentList[1] : lastMerged[1];
    } else {
      mergedList.add(currentList);
    }
  }
  return mergedList;
}

void main() {
  List<List<int>> inputList = [[8, 10], [1, 3], [2, 6], [9, 12]];
  List<List<int>> sortedOutputList = mergeBookingIntervals(inputList);
  
  print(sortedOutputList); 
}