
import 'package:flutter/material.dart';
import 'dart:math';
import '../../../widgets/colors.dart';

class EmployeeAdvancedetailslist extends StatefulWidget {
  final dynamic paymentItem;

  const EmployeeAdvancedetailslist({super.key, required this.paymentItem});

  @override
  State<EmployeeAdvancedetailslist> createState() =>
      _EmployeeAdvancedetailslistState();
}

class _EmployeeAdvancedetailslistState
    extends State<EmployeeAdvancedetailslist> with SingleTickerProviderStateMixin {
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
        title: const Text("تفاصيل السلفة", textDirection: TextDirection.rtl),
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
                      "${widget.paymentItem['name']}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.color),
                    ),
                    const SizedBox(height: 20),
                    buildDetailWithIcon("اسم الموظف", widget.paymentItem['employee_name'], labelStyle, valueStyle, Icons.person, Colors.green),
                    buildDetailWithIcon("البريد الإلكتروني للموظف", widget.paymentItem['employee_user_id'], labelStyle, valueStyle, Icons.email, Colors.teal),
                    buildDetailWithIcon("المستخدم المدخل", widget.paymentItem['user_id'], labelStyle, valueStyle, Icons.manage_accounts, Colors.orange),
                    buildDetailWithIcon("تاريخ القيد", widget.paymentItem['posting_date'], labelStyle, valueStyle, Icons.calendar_today, Colors.teal),
                    buildDetailWithIcon("المدير المباشر", widget.paymentItem['direct_manager'], labelStyle, valueStyle, Icons.supervisor_account, Colors.blue),
                    buildDetailWithIcon("القسم", widget.paymentItem['department'], labelStyle, valueStyle, Icons.apartment, Colors.purple),
                    buildDetailWithIcon("الغرض", widget.paymentItem['purpose'], labelStyle, valueStyle, Icons.description, Colors.deepOrange),
                    buildDetailWithIcon("المبلغ المقدم", widget.paymentItem['advance_amount'], labelStyle, valueStyle, Icons.attach_money, Colors.red),
                    buildDetailWithIcon("المبلغ المطالب", widget.paymentItem['claimed_amount'], labelStyle, valueStyle, Icons.request_page, Colors.indigo),
                    buildDetailWithIcon("المبلغ المدفوع", widget.paymentItem['paid_amount'], labelStyle, valueStyle, Icons.money, Colors.blueGrey),
                    buildDetailWithIcon("الشركة", widget.paymentItem['company'], labelStyle, valueStyle, Icons.business, Colors.brown),
                    buildDetailWithIcon("الحالة", widget.paymentItem['status'], labelStyle, valueStyle, Icons.info, Colors.indigo),
                    buildDetailWithIcon("الحساب", widget.paymentItem['advance_account'], labelStyle, valueStyle, Icons.account_balance, Colors.cyan),
                    buildDetailWithIcon("طريقة الدفع", widget.paymentItem['mode_of_payment'], labelStyle, valueStyle, Icons.payment, Colors.pink),
                    buildDetailWithIcon("ملاحظات", widget.paymentItem['note'], labelStyle, valueStyle, Icons.notes, Colors.grey),
                    buildDetailWithIcon("اسم المستند", widget.paymentItem['document_name'], labelStyle, valueStyle, Icons.article, Colors.black54),
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
    if (value is String && (value.trim().isEmpty || value == 'N/A')) return const SizedBox.shrink();
    if (value is num && value == 0) return const SizedBox.shrink();

    String val = value.toString();

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
              val,
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
