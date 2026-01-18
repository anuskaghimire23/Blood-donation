
import 'package:blooddonation/core/color_utils.dart';
import 'package:blooddonation/core/string_utils.dart';
import 'package:flutter/material.dart';

class DialogBox {
  // Custom Alert Dialog using AlertDialog
  static showAlertBox({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    required VoidCallback onOkPressed,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return 
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          // insetPadding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.125),
          elevation: 8,
          backgroundColor:Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                   icon!=null? 
                   Padding(padding: const EdgeInsets.only(right: 4),
                   child: Icon(icon,color: primaryColor,),
                   
                   )
                   :const SizedBox(),
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                  
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _textButton(context, onOkPressed, okStr),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      },
    );
  }



  static showConfirmBox({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
     VoidCallback? onCancelPressed,
    required void Function() onOkPressed,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          // insetPadding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.125),
          elevation: 8,
          backgroundColor:Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                   icon!=null? 
                   Padding(padding: const EdgeInsets.only(right: 4),
                   child: Icon(icon,color: primaryColor,),
                   
                   )
                   :const SizedBox(),
                    Text(
                      title,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                  
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _textButton(context, onOkPressed, okStr),
                      _textButton(context, onCancelPressed, cancelStr),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _textButton(
      BuildContext context, VoidCallback? onPressed, String textButtonLabel) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        if (onPressed != null) {
          onPressed();
        }
      },
      
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
      ),
      child: Text(
        textButtonLabel,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}