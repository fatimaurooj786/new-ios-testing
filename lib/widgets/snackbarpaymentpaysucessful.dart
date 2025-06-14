// Custom Snackbar in the middle of the screen
  import 'dart:ui';

import 'package:chart_harakia/widgets/colors.dart';
import 'package:flutter/material.dart';

void showpaymentsuccessfulCustomSnackbar(BuildContext context, String message, {SnackBarAction? action, Color backgroundColor = MyColors.color}){
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 80,  // Adjust the vertical position
        left: MediaQuery.of(context).size.width /  10, // Adjust the horizontal position
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 80),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white,),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the snackbar after a delay
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
