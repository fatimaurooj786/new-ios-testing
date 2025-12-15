import 'package:flutter/material.dart';
import 'dart:math';
import 'package:chart_harakia/widgets/colors.dart';

class LeaveDetailScreen extends StatefulWidget {
  final dynamic leaveData;
  const LeaveDetailScreen({super.key, required this.leaveData});

  @override
  State<LeaveDetailScreen> createState() => _LeaveDetailScreenState();
}

class _LeaveDetailScreenState extends State<LeaveDetailScreen>
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
        title: const Text("تفاصيل الإجازة", textDirection: TextDirection.rtl),
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
                    Text(
                      widget.leaveData['leave_type'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyColors.color,
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildDetailWithIcon("رقم المستند", widget.leaveData['name'], labelStyle, valueStyle, Icons.article, Colors.black54),
                    buildDetailWithIcon("رقم الموظف", widget.leaveData['employee'], labelStyle, valueStyle, Icons.badge, Colors.purple),
                    buildDetailWithIcon("اسم الموظف", widget.leaveData['employee_name'], labelStyle, valueStyle, Icons.person, Colors.green),
                    buildDetailWithIcon("البريد الإلكتروني", widget.leaveData['employee_user_id'], labelStyle, valueStyle, Icons.email, Colors.teal),
                    buildDetailWithIcon("نوع الإجازة", widget.leaveData['leave_type'], labelStyle, valueStyle, Icons.beach_access, Colors.blue),
                    buildDetailWithIcon("القسم", widget.leaveData['department'], labelStyle, valueStyle, Icons.apartment, Colors.purple),
                    buildDetailWithIcon("رصيد الإجازة", widget.leaveData['leave_balance'], labelStyle, valueStyle, Icons.av_timer, Colors.orange),
                    buildDetailWithIcon("الموظف البديل", widget.leaveData['substitute_employee'], labelStyle, valueStyle, Icons.swap_horiz, Colors.indigo),
                    buildDetailWithIcon("البريد الإلكتروني للبديل", widget.leaveData['substitute_employee_user'], labelStyle, valueStyle, Icons.alternate_email, Colors.blueGrey),
                    buildDetailWithIcon("المدير المباشر", widget.leaveData['direct_manager'], labelStyle, valueStyle, Icons.supervisor_account, Colors.blue),
                    buildDetailWithIcon("المستخدم المدخل", widget.leaveData['user_id'], labelStyle, valueStyle, Icons.manage_accounts, Colors.orange),
                    buildDetailWithIcon("من تاريخ", widget.leaveData['from_date'], labelStyle, valueStyle, Icons.calendar_today, Colors.teal),
                    buildDetailWithIcon("إلى تاريخ", widget.leaveData['to_date'], labelStyle, valueStyle, Icons.calendar_today, Colors.deepOrange),
                    buildDetailWithIcon("عدد أيام الإجازة", widget.leaveData['total_leave_days'], labelStyle, valueStyle, Icons.date_range, Colors.red),
                    buildDetailWithIcon("الوصف", widget.leaveData['description'], labelStyle, valueStyle, Icons.notes, Colors.grey),
                    buildDetailWithIcon("الحالة", widget.leaveData['status'], labelStyle, valueStyle, Icons.info, Colors.indigo),
                    buildDetailWithIcon("تاريخ القيد", widget.leaveData['posting_date'], labelStyle, valueStyle, Icons.event, Colors.pink),
                    buildDetailWithIcon("الشركة", widget.leaveData['company'], labelStyle, valueStyle, Icons.business, Colors.brown),
                    buildDetailWithIcon("اسم المستند", widget.leaveData['document_name'], labelStyle, valueStyle, Icons.description, Colors.black87),
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
}
