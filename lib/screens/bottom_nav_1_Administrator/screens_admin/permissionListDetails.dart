import 'package:flutter/material.dart';
import 'dart:math';
import 'package:chart_harakia/widgets/colors.dart';

class PermissionDetailScreen extends StatefulWidget {
  final dynamic permissionData;
  const PermissionDetailScreen({super.key, required this.permissionData});

  @override
  State<PermissionDetailScreen> createState() => _PermissionDetailScreenState();
}

class _PermissionDetailScreenState extends State<PermissionDetailScreen>
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
        title: const Text("تفاصيل الإذن", textDirection: TextDirection.rtl),
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
                    //Text(
                     // widget.permissionData['permission_type'] ?? '',
                     // style: const TextStyle(
                      //  fontSize: 16,
                      //  fontWeight: FontWeight.bold,
                      //  color: MyColors.color,
                   //   ),
                 //   ),
                    const SizedBox(height: 20),
                    buildDetailWithIcon("رقم المستند", widget.permissionData['name'],
                        labelStyle, valueStyle, Icons.article, Colors.black54),
                    buildDetailWithIcon("الموظف", widget.permissionData['employee'],
                        labelStyle, valueStyle, Icons.badge, Colors.purple),
                    buildDetailWithIcon("اسم الموظف",
                        widget.permissionData['employee_name'], labelStyle,
                        valueStyle, Icons.person, Colors.indigo),
                    buildDetailWithIcon(
                        "المدير المباشر",
                        widget.permissionData['direct_manager'],
                        labelStyle,
                        valueStyle,
                        Icons.supervisor_account,
                        Colors.blueGrey),
                    buildDetailWithIcon(
                        "البريد الإلكتروني (الموظف)",
                        widget.permissionData['employee_user_id'],
                        labelStyle,
                        valueStyle,
                        Icons.email,
                        Colors.teal),
                    buildDetailWithIcon(
                        "البريد الإلكتروني (المستخدم)",
                        widget.permissionData['user_id'],
                        labelStyle,
                        valueStyle,
                        Icons.email_outlined,
                        Colors.orange),
                    buildDetailWithIcon(
                        "الرصيد المتبقي",
                        widget.permissionData['permission_balance'],
                        labelStyle,
                        valueStyle,
                        Icons.timelapse,
                        Colors.green),
                    buildDetailWithIcon("التاريخ", widget.permissionData['for_date'],
                        labelStyle, valueStyle, Icons.date_range, Colors.red),
                    buildDetailWithIcon("من الوقت", widget.permissionData['from_time'],
                        labelStyle, valueStyle, Icons.access_time, Colors.cyan),
                    buildDetailWithIcon("إلى الوقت", widget.permissionData['to_time'],
                        labelStyle, valueStyle, Icons.access_time_filled, Colors.pink),
                    buildDetailWithIcon(
                        "إجمالي الوقت",
                        widget.permissionData['total_time'],
                        labelStyle,
                        valueStyle,
                        Icons.timer,
                        Colors.amber),
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
    if (value == null || (value is String && value.trim().isEmpty)) {
      return const SizedBox.shrink();
    }

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
}
