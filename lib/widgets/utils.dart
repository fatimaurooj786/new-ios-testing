import 'package:chart_harakia/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';



class Utils {


  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  static Widget showLoaderDialog(BuildContext context, String message) {
    return AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: MyColors.color,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(message),
            ),
          ),
        ],
      ),
    );
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  // we will utilise this for showing errors or success messages
  static successSnackBar(String message) {
    return Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.green,
    );
  }

  static errorSnackBar(String message) {
    return Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.red,
    );
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^\+?\d{12}$');
    return regex.hasMatch(phoneNumber);
  }

  static bool isValidEmail(String email) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}


