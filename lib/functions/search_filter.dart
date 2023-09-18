List<int> makeserachindata({
  required String value,
  required List<Map<String, dynamic>> dataList,
  bool excatatch = false,
}) {
  List<int> _localsearch = [];
  int i = 0;
  for (var element in dataList) {
    element.forEach((keydata, valuedata) {
      if (excatatch) {
        if (valuedata.toString().toLowerCase() == value.toLowerCase()) {
          _localsearch.add(i);
        }
      } else {
        if (valuedata.toString().toLowerCase().contains(value.toLowerCase())) {
          _localsearch.add(i);
        }
      }
    });
    i++;
  }

  return _localsearch.toSet().toList();
}
