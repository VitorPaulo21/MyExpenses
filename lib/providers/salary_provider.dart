import 'package:flutter/cupertino.dart';
import 'package:my_expenses/models/advance.dart';
import 'package:my_expenses/models/salary.dart';

class SalaryProvider with ChangeNotifier {
  List<Salary> salariesList = [];

  List<Salary> getMonthSalaries(DateTime date) {
    return salariesList
        .where((salary) => salary.date.compareTo(date) == 0)
        .toList();
  }

  List<Advance> getTotalMonthAdvances(DateTime date) {
    List<Advance> advances = [];
    getMonthSalaries(date)
        .forEach((salary) => advances.addAll(salary.advanceList));
    return advances;
  }

  List<Advance> getTotalDebitMonthAdvances(DateTime date) {
    List<Advance> advances = [];
    getMonthSalaries(date)
        .forEach((salary) => advances.addAll(salary.debitAdvanceList));
    return advances;
  }

  double getMonthTotalEntriesValue(DateTime date) {
    return getMonthSalaries(date).fold<double>(0,
        (previousValue, salary) => salary.getAllEntryValue() + previousValue);
  }

  double getMonthTotalAdvancesValue(DateTime date) {
    return getTotalMonthAdvances(date).fold(
        0, (previousValue, advance) => advance.getAllValue() + previousValue);
  }

  double getMonthTotalDebitAdvancesValue(DateTime date) {
    return getTotalDebitMonthAdvances(date).fold(
        0, (previousValue, advance) => advance.getAllValue() + previousValue);
  }

  double getMonthTotalLiquidSalaryValue(DateTime date) {
    return (getMonthTotalEntriesValue(date) +
            getMonthTotalAdvancesValue(date)) -
        getMonthTotalDebitAdvancesValue(date);
  }
}
