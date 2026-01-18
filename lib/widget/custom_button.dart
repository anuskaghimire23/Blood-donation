import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function()? onPressed;
  Widget? child;
  Color? backgroundColor;
  double? width;
  CustomButton({super.key, this.onPressed, this.child, this.backgroundColor,this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
          height: 45,
          width: width ?? MediaQuery.of(context).size.width * 0.95,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  backgroundColor: backgroundColor ?? const Color.fromARGB(255, 30, 123, 165)),
              onPressed: onPressed,
              child: child)),
    );
  }
}
