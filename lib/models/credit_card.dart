import 'package:my_expenses/models/expense.dart';

class CreditCard {
  String name;
  double _value;
  Map<String, List<Expense>> expenses = {};
  int closingDateDay;
  int dueDateDay;

  CreditCard(
      {required this.name,
      required this.closingDateDay,
      required this.dueDateDay,
      double value = 0})
      : _value = value;

  set value(double value) {
    _value = value;
  }
  double get value => _value;
  double getValueByMonth(String month) {
    if (expenses.containsKey(month)) {
      
      return _value +
          expenses[month]!.fold<double>(
              0, (previousValue, actual) => actual.value + previousValue);
    } else {

    return _value;
    }
  }
}
