import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class MonthProvider with ChangeNotifier {
  String _month = DateFormat("MM/yyyy").format(DateTime.now());

  String get month => _month;

  set month(String month) {
    _month = month;
    notifyListeners();
  }
}
