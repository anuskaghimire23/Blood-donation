import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  List<String>? items;
  String? labelText;
  final String? value; 
  String? Function(String?)? validator;
  Function(String?)? onChanged;
  CustomDropDownButton(
      {super.key, this.items,this.value, this.labelText, this.onChanged, this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      // padding: EdgeInsets.all(20),
      child: DropdownButtonFormField(
          validator: validator,
          decoration: InputDecoration(
              labelText: labelText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          value: value,
          items: items
              ?.map((e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ))
              .toList(),
          onChanged: onChanged),
    );
  }
}
