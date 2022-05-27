import 'package:flutter/material.dart';
import 'package:my_expenses/providers/cards_provider.dart';
import 'package:my_expenses/providers/expensesProvider.dart';
import 'package:my_expenses/providers/month_provider.dart';
import 'package:my_expenses/providers/salary_provider.dart';
import 'package:my_expenses/screens/cards_screen.dart';
import 'package:my_expenses/screens/home_screen.dart';
import 'package:my_expenses/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CardsProvider>(
          create: (ctx) => CardsProvider(),
        ),
        ChangeNotifierProvider<SalaryProvider>(
          create: (ctx) => SalaryProvider(),
        ),
        ChangeNotifierProvider<MonthProvider>(
          create: (ctx) => MonthProvider(),
        ),
        ChangeNotifierProxyProvider3<MonthProvider, SalaryProvider,
            CardsProvider, ExpensesProvider>(
          create: (ctx) => ExpensesProvider(null, null, null),
          update: (ctx, month, salary, cards, expenses) {
            return ExpensesProvider(cards, salary, month);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Meus Gastos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.HOME: (ctx) => HomeScreen(),
          AppRoutes.CARDS_SCREEN: (ctx) => CardsScreen(),
        },
      ),
    );
  }
}

