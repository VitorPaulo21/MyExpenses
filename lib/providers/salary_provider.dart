import 'package:flutter/material.dart';
import 'package:my_expenses/models/salary.dart';

class SalaryProvider with ChangeNotifier {
  Map<String, List<Salary>> _salaryies = {
    "05/2022": [
      Salary(value: 1200, receiptDate: 5, advanceDate: 20, advance: 500)
    ],
    "06/2022": [
      Salary(value: 1200, receiptDate: 5, advanceDate: 20, advance: 500)
    ]
  };

  addSalary(String month, Salary salary) {
    _salaryies[month]?.add(salary);
    notifyListeners();
  }

  Map<String, List<Salary>> get salaryies => {..._salaryies};

  double getTotalSalaryValueByMonth(String month) {
    if (_salaryies.containsKey(month)) {
      return _salaryies[month]!.fold<double>(
          0, (previousValue, element) => element.value + previousValue);
    } else {
      return 0;
    }
  }
  double getTotalAdvanceByMonth(String month) {
    if (_salaryies.containsKey(month)) {
      return _salaryies[month]!.fold<double>(
          0, (previousValue, element) => element.advance + previousValue);
    } else {
      return 0;
    }
  }
}
