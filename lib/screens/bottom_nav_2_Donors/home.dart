import 'package:flutter/material.dart';

class HomeScreenContentDoners extends StatelessWidget {
  const HomeScreenContentDoners({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Welcome to the Donors!',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}