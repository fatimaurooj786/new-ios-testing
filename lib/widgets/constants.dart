import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:get/get.dart';



final BoxDecoration decoration = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  color: Colors.white,
);

final BoxDecoration quantityDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10.0),
  color: MyColors.color.withOpacity(0.1),
);

SizedBox space = const SizedBox(height: 5);
SizedBox space2 = const SizedBox(height: 10);
SizedBox bigSpace = SizedBox(height: Get.height * 0.015);
SizedBox rowSpace = const SizedBox(width: 5);
SizedBox rowSpace2 = const SizedBox(width: 10);
EdgeInsets padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16);


Widget indicator() {
  return const Center(
    child: CircularProgressIndicator(
      color: MyColors.color,
    ),
  );
}
