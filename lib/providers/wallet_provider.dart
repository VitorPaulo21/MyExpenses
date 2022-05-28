import 'package:flutter/cupertino.dart';
import 'package:my_expenses/models/wallet.dart';

class WalletProvider with ChangeNotifier {
  List<Wallet> wallets = [];

  Wallet getMonthWallet(DateTime date) {
    return wallets.firstWhere((wallet) => wallet.month == date.month);
  }
}
