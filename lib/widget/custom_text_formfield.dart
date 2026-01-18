import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextformfield extends StatelessWidget {
  Function(String)? onChanged;
  String? Function(String?)? validator;
  String? labelText;
  String? hintText;
  Icon? prefixIcon;
  Widget? suffixIcon;
  bool? obscureText;
  TextInputType? keyboardType;
  InputDecoration? decoration;
  List<TextInputFormatter>? inputFormatters;
  CustomTextformfield(
      {super.key,
      this.onChanged,
      this.validator,
      this.labelText,
      this.hintText,
      this.obscureText = false,
      this.decoration,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.inputFormatters,   });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // suffixIcon: Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }
}
