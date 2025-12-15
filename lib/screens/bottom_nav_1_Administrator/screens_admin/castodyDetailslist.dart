import 'package:flutter/material.dart';
import 'dart:math';
import '../../../widgets/colors.dart';

class CastodyDetailsScreen extends StatefulWidget {
  final dynamic custodyItem;

  const CastodyDetailsScreen({super.key, required this.custodyItem});

  @override
  State<CastodyDetailsScreen> createState() => _CastodyDetailsScreenState();
}

class _CastodyDetailsScreenState extends State<CastodyDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = const TextStyle(
        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black);
    TextStyle valueStyle = const TextStyle(fontSize: 12, color: Colors.black);

    Color randomLogoBorderColor = getRandomColor();
    Color randomCardBorderColor = getRandomColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل العهدة", textDirection: TextDirection.rtl),
        backgroundColor: MyColors.color,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _logoSlideAnimation,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.only(bottom: 20, top: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: randomLogoBorderColor,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            /// Card with custody details
            SlideTransition(
              position: _cardSlideAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: randomCardBorderColor,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.custodyItem['name']}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.color),
                    ),
                    const SizedBox(height: 20),

                    buildDetailWithIcon(
                      "اسم العنصر",
                      widget.custodyItem['item'],
                      labelStyle,
                      valueStyle,
                      Icons.widgets,
                      Colors.deepOrange,
                    ),
                    buildDetailWithIcon(
                      "اسم العنصر كامل",
                      widget.custodyItem['item_name'],
                      labelStyle,
                      valueStyle,
                      Icons.label,
                      Colors.blue,
                    ),
                    buildDetailWithIcon(
                      "المجموعة",
                      widget.custodyItem['item_group'],
                      labelStyle,
                      valueStyle,
                      Icons.category,
                      Colors.green,
                    ),
                    buildDetailWithIcon(
                      "تاريخ التسليم",
                      widget.custodyItem['delivery_date'],
                      labelStyle,
                      valueStyle,
                      Icons.date_range,
                      Colors.red,
                    ),
                    buildDetailWithIcon(
                      "المسؤول",
                      widget.custodyItem['person_in_charge'],
                      labelStyle,
                      valueStyle,
                      Icons.supervisor_account,
                      Colors.teal,
                    ),
                    buildDetailWithIcon(
                      "اسم الموظف",
                      widget.custodyItem['employee_name'],
                      labelStyle,
                      valueStyle,
                      Icons.person,
                      Colors.purple,
                    ),
                    buildDetailWithIcon(
                      "نوع العهدة",
                      widget.custodyItem['custody_type'],
                      labelStyle,
                      valueStyle,
                      Icons.assignment,
                      Colors.indigo,
                    ),
                    buildDetailWithIcon(
                      "رقم تسلسلي",
                      widget.custodyItem['serial_no'],
                      labelStyle,
                      valueStyle,
                      Icons.confirmation_number,
                      Colors.brown,
                    ),
                    buildDetailWithIcon(
                      "تاريخ الاستلام",
                      widget.custodyItem['receiving_date'],
                      labelStyle,
                      valueStyle,
                      Icons.event_available,
                      Colors.cyan,
                    ),
                    buildDetailWithIcon(
                      "اسم المستند",
                      widget.custodyItem['document_name'],
                      labelStyle,
                      valueStyle,
                      Icons.description,
                      Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable row with icon + label + value
  Widget buildDetailWithIcon(
    String label,
    dynamic value,
    TextStyle labelStyle,
    TextStyle valueStyle,
    IconData icon,
    Color iconColor,
  ) {
    if (value == null) return const SizedBox.shrink();
    if (value is String && (value.trim().isEmpty || value == 'N/A')) {
      return const SizedBox.shrink();
    }
    if (value is num && value == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 6),
          Text("$label :", style: labelStyle),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value.toString(),
              style: valueStyle,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  /// Random border colors for nice UI
  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
   