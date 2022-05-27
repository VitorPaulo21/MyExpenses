import 'package:flutter/material.dart';

class OutlineTextField extends StatelessWidget {
  String label;
  TextEditingController controller;
  bool isNumber;
  String prefix;
  String? Function(String?)? validator;
  bool useDecimal;
  OutlineTextField(
      {Key? key,
      this.label = "",
      required this.controller,
      this.isNumber = false,
      this.prefix = "",
      this.validator,
      this.useDecimal = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isNumber
          ? TextInputType.numberWithOptions(decimal: useDecimal)
          : null,
      controller: controller,
      decoration: InputDecoration(
        prefixText: prefix.isEmpty ? null : prefix,
        label: Text(label),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: Colors.pinkAccent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      validator: validator,
    );
  }
}
