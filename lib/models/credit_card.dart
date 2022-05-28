import 'package:my_expenses/models/expense.dart';

class CreditCard {
  int closingDay;
  int dueDay;
  List<Expense> expenseList = [];
  CreditCard(
      {required this.closingDay,
      required this.dueDay,
      required this.expenseList});

  double valueByMonth(DateTime date) {
    return expenseList
        .where((expense) => expense.date.month == date.month)
        .fold<double>(
            0, (previousValue, expense) => expense.value = previousValue);
  }
}
