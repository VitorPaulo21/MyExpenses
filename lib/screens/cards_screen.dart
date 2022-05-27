import 'package:flutter/material.dart';
import 'package:my_expenses/models/credit_card.dart';
import 'package:my_expenses/providers/cards_provider.dart';
import 'package:my_expenses/providers/month_provider.dart';
import 'package:provider/provider.dart';

import '../components/outline_text_field.dart';
import '../functions/functions.dart';

class CardsScreen extends StatelessWidget {
  CardsScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    CardsProvider cardsProvider = Provider.of<CardsProvider>(context);
    MonthProvider monthProvider = Provider.of<MonthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Cartões"),
        centerTitle: true,
        actions: [
          Center(
            child: Text(
              "-R\$${cardsProvider.cards.fold<double>(0, (previousValue, element) => element.getValueByMonth(monthProvider.month) + previousValue)}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
        ],
      ),
      body: cardsProvider.cards.isEmpty
          ? const Center(
              child: Text(
                "Sem Cartoes...",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: cardsProvider.cards.length,
              itemBuilder: (ctx, index) {
                double cardValue = cardsProvider.cards[index]
                    .getValueByMonth(monthProvider.month);
                return Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      trailing: FittedBox(
                        //TODO implement the date here when date provider is ready
                        child: Text(
                          (cardValue > 0 ? "-" : "") +
                              "R\$" +
                              cardValue
                                  .toStringAsFixed(2),
                          style: TextStyle(
                              color:
                                  cardValue == 0 ? Colors.green : Colors.red),
                        ),
                      ),
                      leading: const Icon(Icons.credit_card),
                      title: Text(cardsProvider.cards[index].name),
                      onTap: () {
                        Functions.cardEditBottomSheet(
                          context,
                          cardsProvider,
                          cardsProvider.cards[index],
                          monthProvider
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          Functions.cardEditBottomSheet(
              context, cardsProvider, null, monthProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }


}
