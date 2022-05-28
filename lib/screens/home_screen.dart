import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/components/app_drawer.dart';
import 'package:my_expenses/models/credit_card.dart';
import 'package:my_expenses/models/expense.dart';

import 'package:my_expenses/providers/cards_provider.dart';
import 'package:my_expenses/providers/expensesProvider.dart';
import 'package:my_expenses/providers/month_provider.dart';
import 'package:my_expenses/providers/salary_provider.dart';
import 'package:my_expenses/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    ExpensesProvider expensesProvider = Provider.of<ExpensesProvider>(context);
    CardsProvider cardsProvider = Provider.of<CardsProvider>(context);
    SalaryProvider salaryProvider = Provider.of<SalaryProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Meus Gastos"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GlobalKey<FormState> formKey = GlobalKey<FormState>();
          AddExpense(context, formKey, expensesProvider, cardsProvider);
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        
        children: [
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text(
              (expensesProvider.allValueByDate(focusedDay) < 0 ? "-" : "") +
                  "R\$${expensesProvider.allValueByDate(focusedDay).abs().toStringAsFixed(2)}",
              style: TextStyle(
                color: expensesProvider.allValueByDate(focusedDay) >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            trailing: Icon(Icons.edit),
          ),
          Expanded(
            child: TableCalendar<dynamic>(
                // eventLoader: (date) {
                //   return cardsProvider.cards
                //       .where((element) =>
                //           element.dueDateDay == date.day ||
                //           date
                //                   .add(Duration(days: element.closingDateDay))
                //                   .day ==
                //               element.dueDateDay)
                //       .toList();
                // },
                
                onPageChanged: (date) {
                  setState(() {
                    focusedDay = date;
                  });
                  Provider.of<MonthProvider>(context, listen: false).month =
                      date.month;
                      
                },
                calendarBuilders: CalendarBuilders<Expense>(
                  
                  selectedBuilder: (context, day, focusedDay) {
                    double dayValue = expensesProvider.allValueByDate(day);
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[200]),
                          child: Text(DateFormat("dd").format(day)),
                        ),
                        FittedBox(
                          child: Text(
                            (dayValue > 0 ? "+" : "") +
                                dayValue.toStringAsFixed(2),
                            style: TextStyle(
                                color: dayValue == 0
                                    ? Colors.amber
                                    : dayValue > 0
                                        ? Colors.green
                                        : Colors.red),
                          ),
                        )
                      ],
                    );
                  },
                ),
                selectedDayPredicate: (date) {
                  String formatedDate = DateFormat("MM/yyyy").format(date);
                  DateTime advanceDate =
                      DateTime(date.year, date.month + 1, date.day);
                  String advanceDateFormated =
                      DateFormat("MM/yyyy").format(advanceDate);
                  
                  bool isSomeEvent = false;

                  if (salaryProvider.salaryies.containsKey(formatedDate)) {
                    isSomeEvent = salaryProvider.salaryies[formatedDate]!
                        .any((salary) => salary.receiptDate == date.day);
                  }
                  if (salaryProvider.salaryies
                          .containsKey(advanceDateFormated) &&
                      !isSomeEvent) {
                    isSomeEvent = salaryProvider.salaryies[advanceDateFormated]!
                        .any((salary) => salary.advanceDate == advanceDate.day);
                  }

                  return isSomeEvent;
                },
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarFormat: CalendarFormat.month,
                currentDay: DateTime.now(),
                focusedDay: focusedDay,
                firstDay: DateTime.now().subtract(Duration(days: 365 * 2)),
                lastDay: DateTime.now().add(Duration(days: 365 * 4))),
          ),
        ],
      ),
    );
  }
bool compareDates(DateTime date1, DateTime date2) {
    return DateFormat("dd/MM/yyyy").format(date1) ==
        DateFormat("dd/MM/yyyy").format(date2);
  }

  String formatDate(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }
  Future<dynamic> AddExpense(BuildContext context, GlobalKey<FormState> formKey,
      ExpensesProvider expensesProvider, CardsProvider cardsProvider) {
    DateTime? expenseDate;
    CreditCard? selectedCard =
        cardsProvider.cards.isEmpty ? null : cardsProvider.cards[0];
    TextEditingController valueController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setState) => GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.60,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Adicionar Gasto",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: valueController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixText: "R\$ ",
                                label: const Text("Valor:"),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.pink, width: 2),
                                ),
                              ),
                              validator: (txt) {
                                if (txt == null) {
                                  return "O Valor está vazio";
                                } else if (txt.isEmpty) {
                                  return "O Valor está vazio";
                                } else if (double.tryParse(txt) == null) {
                                  return "Valor numérico inválido";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: descriptionController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                label: const Text("Descrião:"),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.pink, width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<CreditCard>(
                              value: selectedCard,
                              decoration: InputDecoration(
                                label: Text("Cartão: "),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.pink, width: 2),
                                ),
                              ),
                              items: cardsProvider.cards.isNotEmpty
                                  ? cardsProvider.cards
                                      .map<DropdownMenuItem<CreditCard>>(
                                          (card) {
                                      return DropdownMenuItem<CreditCard>(
                                        child: Text(card.name),
                                        value: card,
                                      );
                                    }).toList()
                                  : [],
                              onChanged: (card) {
                                selectedCard = card;
                              },
                              validator: (card) {
                                if (card == null ||
                                    cardsProvider.cards.isEmpty ||
                                    selectedCard == null) {
                                  Navigator.pushNamed(
                                      context, AppRoutes.CARDS_SCREEN);
                                  return "Nenhum Cartao Selecionado";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Text(
                                  "Data:",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    onPressed: () async {
                                      expenseDate = await PickDate();

                                      setState(() {});
                                    },
                                    child: Text(expenseDate == null
                                        ? "dd/mm/yy"
                                        : DateFormat("dd/MM/yy")
                                            .format(expenseDate!)),
                                  ),
                                ),
                              
                                
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  bool isValid =
                                      formKey.currentState?.validate() ?? false;
                                  if (isValid) {
                                    if (expenseDate != null) {
                                      
                                        // TODO add expense here
                                      expensesProvider.addExpense(
                                          Expense(
                                              value: double.parse(
                                                  valueController.text),
                                              description:
                                                  descriptionController.text,
                                              date: expenseDate!),
                                          selectedCard!);
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                   
                                    } else {
                                      infoDialog(
                                          "A Data de Fechamento nao pode estar vazia");
                                    }
                                  }
                                },
                                child: Text("Adicionar"),
                                style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<DateTime?> PickDate({DateTime? initialDate, DateTime? endDate}) async {
    initialDate ??= DateTime.now().subtract(const Duration(days: 365 * 2));
    endDate ??= DateTime.now().add(const Duration(days: 365 * 4));
    DateTime? dateTime;
    await showDatePicker(
            context: context,
            initialDate: DateTime.now().isBefore(initialDate)
                ? initialDate
                : DateTime.now(),
            firstDate: initialDate,
            lastDate: endDate)
        .then((value) => dateTime = value);
    return dateTime;
  }

  void infoDialog(String text) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Alerta"),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text("Ok"),
              )
            ],
          );
        });
  }
}
