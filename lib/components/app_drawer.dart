import 'package:flutter/material.dart';
import 'package:my_expenses/providers/expensesProvider.dart';
import 'package:my_expenses/utils/app_routes.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Center(child: Icon(Icons.attach_money)),
          ),
          title: Text(
            "R\$ " +
                Provider.of<ExpensesProvider>(context, listen: false)
                    .wallet
                    .value
                    .toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              icon: Icon(Icons.close),
            )
          ],
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.CARDS_SCREEN);
              },
              leading: Icon(Icons.credit_card),
              title: Text("Cartoes"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.attach_money),
              title: Text("Salário"),
            )
          ],
        ),
      ),
    );
  }
}
