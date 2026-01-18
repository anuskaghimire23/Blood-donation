

    import 'package:flutter/material.dart';

class CustomProfileOptionsButton extends StatelessWidget {
  final IconData? icon;
  final String data;
  final VoidCallback? onPressed;

  const CustomProfileOptionsButton({
    super.key,
    required this.icon,
    required this.data,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 247, 82, 82), // Background white
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 3), // subtle shadow
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: onPressed,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
              child: Row(
                children: [
                  Icon(icon, size: 24, color: const Color.fromARGB(255, 38, 21, 21)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      data,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
