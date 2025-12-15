import 'package:flutter/material.dart';

class Castodymanagement extends StatefulWidget {
  const Castodymanagement({super.key});

  @override
  State<Castodymanagement> createState() => _CastodymanagementState();
}

class _CastodymanagementState extends State<Castodymanagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Casetody Management'),
      ),
    );
  }
}