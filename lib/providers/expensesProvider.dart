import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/models/credit_card.dart';
import 'package:my_expenses/models/expense.dart';
import 'package:my_expenses/models/salary.dart';

import 'package:my_expenses/models/wallet.dart';
import 'package:my_expenses/providers/cards_provider.dart';
import 'package:my_expenses/providers/month_provider.dart';

import 'salary_provider.dart';

class ExpensesProvider with ChangeNotifier {
  Wallet _wallet = Wallet(0);

  CardsProvider? cardsProvider;
  SalaryProvider? salaryProvider;
  MonthProvider? monthProvider;
  ExpensesProvider(this.cardsProvider, this.salaryProvider, this.monthProvider);
  set wallet(Wallet newWallet) => _wallet = newWallet;
  Wallet get wallet {
    calculateWallet();
    return _wallet;
  }

  void addExpense(Expense expense, CreditCard card) {
    cardsProvider!.addExpense(expense, card);
    notifyListeners();
  }
  // calculateWallet();

  bool _compareDates(DateTime date1, DateTime date2) {
    return DateFormat("dd/MM/yyyy").format(date1) ==
        DateFormat("dd/MM/yyyy").format(date2);
  }

  String formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }

  double monthExpenses(String month) {
    return cardsProvider!.cardsTotalValueByMonth(month);
  }

  double allValueByDate(DateTime date) {
    String formateDate = DateFormat("MM/yyyy").format(date);
    String advanceDate = DateFormat("MM/yyyy")
        .format(DateTime(date.year, date.month + 1, date.day));
    double monthSalaryValue =
        salaryProvider!.getTotalSalaryValueByMonth(formateDate);
    double monthCardValue = cardsProvider!.cardsTotalValueByMonth(formateDate);
    double dayCardsValue = 0;
    
    //Se eu tenho um salario esse mes
    if (salaryProvider!.salaryies.containsKey(formateDate)) {
      //verifica se todas as datas de recebimento de salario desse mes estao antes da data fornecida
      if (salaryProvider!.salaryies[formateDate]!.every((salary) =>
          DateTime(date.year, date.month, salary.receiptDate).isAfter(date))) {
        //se sim verifica se mes que vem tem uma data com salario pra que se tiver verifique se la tem adiantamento
        if (salaryProvider!.salaryies.containsKey(advanceDate)) {
          //verifica se algum salario do mes que vem possui adiantamento maior que 0 e que a data seja igual a fornecida
          if (salaryProvider!.salaryies[advanceDate]!.any((salary) =>
              salary.advance > 0 && salary.advanceDate == date.day)) {
            return salaryProvider!.salaryies[advanceDate]!
                .where((salary) =>
                    salary.advance > 0 && salary.advanceDate == date.day)
                .fold<double>(
                  0,
                  (previousValue, salary) => salary.advance + previousValue,
                );
          } else {
            //caso contrario cria um valor no dia vinte referente ao que sobrou do salario desse mes menos as despesas
            if (date.day ==
                salaryProvider!.salaryies[advanceDate]!.first.advanceDate) {
              return 0;
            } else {
              return 0;
            }
          }
        } else {
          //caso contrario cria um valor no dia vinte referente ao que sobrou do salario desse mes menos as despesas
          return 0;
        }
      } else {
        return 0;

      }
    } else {
      return 0;
    }
  }

  void calculateWallet() {
    //TODO implement the date here when date provider is ready
    _wallet.value =
        salaryProvider!.getTotalSalaryValueByMonth(monthProvider!.month) -
            cardsProvider!.cardsTotalValueByMonth(monthProvider!.month);

    // _wallet.value = expenses.values
    //     .map<List<double>>((lists) => lists.map((e) => e.value).toList())
    //     .fold<double>(
    //         0,
    //         (previousValue, element) =>
    //             element.fold<double>(
    //                 0, (previousValue, element) => element + previousValue) +
    //             previousValue);
  }
}

// List<CreditCard> loadMonthCards = cardsProvider!.cards
//         .where((card) =>
//             card.expenses.containsKey(
//             DateFormat("MM/yyyy").format(date),
//           ),
//         )
//         .toList();
//     double fixCost = ((salaryProvider!.getTotalSalaryValueByMonth(
//                 DateFormat("MM/yyyy").format(date)) +
//             salaryProvider!.getTotalAdvanceByMonth(DateFormat("MM/yyyy")
//                 .format(
//                 DateTime(date.year, date.month + 1, date.day),
//               ),
//             )) -
//         cardsProvider!
//             .cardsTotalValueByMonth(DateFormat("MM/yyyy").format(date)));

//     if (loadMonthCards.isNotEmpty) {
//       return fixCost -
//           loadMonthCards
//           .map((cards) => cards.expenses[DateFormat("MM/yyyy").format(date)]!
//               .fold<double>(
//                   0, (previousValue, element) => element.value + previousValue))
//           .fold(0, (previousValue, element) => element + previousValue);
//     } else {
//       return fixCost;
//     }