import 'package:flutter/material.dart';
import 'package:my_expenses/providers/month_provider.dart';

import '../components/outline_text_field.dart';
import '../models/credit_card.dart';
import '../providers/cards_provider.dart';

class Functions {
  static Future<dynamic> cardEditBottomSheet(
      BuildContext context,
      CardsProvider cardsProvider,
      CreditCard? card,
      MonthProvider monthProvider) {
    TextEditingController cardNameController = TextEditingController();
    TextEditingController initialCardValueController = TextEditingController();
    TextEditingController dueDateController = TextEditingController();
    TextEditingController closingDateController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    if (card != null) {
      cardNameController.text = card.name;
      //TODO when date provider is ready implement the call here
      initialCardValueController.text =
          card.getValueByMonth(monthProvider.month) == 0
          ? ""
              : card.getValueByMonth(monthProvider.month).toStringAsFixed(2);
      dueDateController.text = card.dueDateDay.toString();
      closingDateController.text = card.closingDateDay.toString();
    }
    void submitForm() {
      bool isValid = formKey.currentState?.validate() ?? false;

      if (isValid) {
        if (card != null) {
          card.name = cardNameController.text;
          card.closingDateDay = int.parse(closingDateController.text);
          card.dueDateDay = int.parse(dueDateController.text);
          card.value = initialCardValueController.text.isEmpty
              ? 0
              : double.parse(initialCardValueController.text);
        }
        cardsProvider.addCards(
          card ??
              CreditCard(
                name: cardNameController.text,
                closingDateDay: int.parse(closingDateController.text),
                dueDateDay: int.parse(dueDateController.text),
                value: initialCardValueController.text.isEmpty
                    ? 0
                    : double.parse(initialCardValueController.text),
              ),
        );
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    return showModalBottomSheet(

        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        )),
        context: context,
        
        builder: (ctx) {
          return GestureDetector(
              onDoubleTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            card == null ? "Cadastrar Cartao" : "Editar Cartao",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          OutlineTextField(
                            label: "Nome do Cartão:",
                            controller: cardNameController,
                            validator: (text) {
                              if (text?.isEmpty ?? false) {
                                return "O nome está vazio";
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          OutlineTextField(
                            label: "Valor Inicial:",
                            controller: initialCardValueController,
                            isNumber: true,
                            useDecimal: true,
                            prefix: "R\$ ",
                            validator: (text) {
                              if (text != null) {
                                if (double.tryParse(text) == null) {
                                  return "Valor nao numérico";
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          OutlineTextField(
                            controller: dueDateController,
                            label: "Dia do Vencimento:",
                            isNumber: true,
                            validator: (text) {
                              if (text != null) {
                                if (text.isEmpty) {
                                  return "Dia do vencimento vazio";
                                } else if (int.tryParse(text) == null) {
                                  return "Valor nao numerico";
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          OutlineTextField(
                            controller: closingDateController,
                            label: "Dias p/ Fechamento:",
                            isNumber: true,
                            validator: (text) {
                              if (text != null) {
                                if (text.isEmpty) {
                                  return "Dia do fechamento vazio";
                                } else if (int.tryParse(text) == null) {
                                  return "Valor nao numerico";
                                }
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: MaterialButton(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                highlightColor: Colors.pink,
                                color: Theme.of(context).colorScheme.primary,
                                splashColor: Colors.pink,
                                onPressed: () {
                                  submitForm();
                                },
                                child: const Text(
                                  "Salvar",
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
              
            
          );
        });
  }
}
