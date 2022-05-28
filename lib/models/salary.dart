import 'package:my_expenses/models/advance.dart';
import 'package:my_expenses/models/entry.dart';

class Salary {
  List<Entry> entryList = [];
  List<Advance> advanceList = [];
  List<Advance> debitAdvanceList = [];
  DateTime date;

  Salary(DateTime this.date);

  double getAllAdvancesValue() {
    return advanceList.fold<double>(
        0, (previousValue, advance) => advance.getAllValue() + previousValue);
  }

  double getAllDebitAdvancesValue() {
    return debitAdvanceList.fold<double>(
        0, (previousValue, advance) => advance.getAllValue() + previousValue);
  }

  double getAllEntryValue() {
    return entryList.fold<double>(
        0, (previousValue, entry) => entry.value + previousValue);
  }

  double getLiquidsalaryValue() {
    return (getAllEntryValue() + getAllAdvancesValue()) -
        getAllDebitAdvancesValue();
  }
}
