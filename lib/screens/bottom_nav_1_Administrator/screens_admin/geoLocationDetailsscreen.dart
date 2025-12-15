import 'package:flutter/material.dart';
import 'dart:math';
import 'package:chart_harakia/widgets/colors.dart';

class GeoLocationDetailsScreen extends StatefulWidget {
  final dynamic locationData; // Pass one location item (from JSON list)

  const GeoLocationDetailsScreen({super.key, required this.locationData});

  @override
  State<GeoLocationDetailsScreen> createState() =>
      _GeoLocationDetailsScreenState();
}

class _GeoLocationDetailsScreenState extends State<GeoLocationDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<Offset> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
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
        automaticallyImplyLeading: false,
        title: const Text("تفاصيل الموقع", textDirection: TextDirection.rtl),
        backgroundColor: MyColors.color,
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
                    // Show location name
                    Text(
                      widget.locationData['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyColors.color,
                      ),
                    ),
                    const SizedBox(height: 20),

                    buildDetailWithIcon("اسم المستند",
                        widget.locationData['document_name'], labelStyle, valueStyle, Icons.description, Colors.blue),

                    const SizedBox(height: 20),
                    const Text(
                      "تفاصيل الموظفين المرتبطين:",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 10),

                    // Employees List
                    if (widget.locationData['accounts_details'] != null &&
                        widget.locationData['accounts_details'].isNotEmpty)
                      Column(
                        children: List.generate(
                          widget.locationData['accounts_details'].length,
                          (index) {
                            final emp = widget.locationData['accounts_details'][index];
                            return buildEmployeeCard(
                                emp['employee_id'], emp['employee_name']);
                          },
                        ),
                      )
                    else
                      const Text("لا يوجد موظفين", textDirection: TextDirection.rtl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailWithIcon(
    String label,
    dynamic value,
    TextStyle labelStyle,
    TextStyle valueStyle,
    IconData icon,
    Color iconColor,
  ) {
    if (value == null) return const SizedBox.shrink();
    if (value is String && value.trim().isEmpty) return const SizedBox.shrink();

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

  Widget buildEmployeeCard(String? empId, String? empName) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Icon(Icons.person, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text("اسم الموظف: ${empName ?? ''}",
                    style: const TextStyle(fontSize: 12)),
                Text("رقم الموظف: ${empId ?? ''}",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
