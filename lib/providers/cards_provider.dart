import 'package:flutter/cupertino.dart';
import 'package:my_expenses/models/credit_card.dart';

class CardsProvider with ChangeNotifier {
  List<CreditCard> cards = [];

  void addCard(CreditCard card) {
    if (!updateCard(card)) {
      cards.add(card);
      notifyListeners();
    }
  }

  void removeCard(CreditCard card) {
    if (cards.contains(card)) {
      cards.remove(card);
      notifyListeners();
    }
  }

  bool updateCard(CreditCard card) {
    if (cards.contains(card)) {
      cards.insert(cards.indexOf(card), card);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
  double getAllCardValuesByMonth(DateTime date) {
    return cards.fold<double>(
        0, (previousValue, card) => card.valueByMonth(date) + previousValue);
  }
}
