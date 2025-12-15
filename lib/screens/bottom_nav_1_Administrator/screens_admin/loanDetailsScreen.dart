import 'package:flutter/material.dart';
import 'dart:math';
import 'package:chart_harakia/widgets/colors.dart';

class LoanDetailScreen extends StatefulWidget {
  final dynamic loanData;
  const LoanDetailScreen({super.key, required this.loanData});

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen>
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
        title: const Text("تفاصيل القرض", textDirection: TextDirection.rtl),
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
                      widget.loanData['loan_type'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MyColors.color,
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildDetailWithIcon("رقم المستند", widget.loanData['name'], labelStyle, valueStyle, Icons.article, Colors.black54),
                    buildDetailWithIcon("نوع المتقدم", widget.loanData['applicant_type'], labelStyle, valueStyle, Icons.person, Colors.green),
                    buildDetailWithIcon("رقم الموظف", widget.loanData['applicant'], labelStyle, valueStyle, Icons.badge, Colors.purple),
                    buildDetailWithIcon("اسم الموظف", widget.loanData['employee_name'], labelStyle, valueStyle, Icons.person, Colors.indigo),
                    buildDetailWithIcon("البريد الإلكتروني", widget.loanData['user_id'], labelStyle, valueStyle, Icons.email, Colors.teal),
                    buildDetailWithIcon("نوع القرض", widget.loanData['loan_type'], labelStyle, valueStyle, Icons.account_balance, Colors.blue),
                    buildDetailWithIcon("طريقة السداد", widget.loanData['repayment_method'], labelStyle, valueStyle, Icons.payment, Colors.deepOrange),
                    buildDetailWithIcon("طريقة الجدولة", widget.loanData['repayment_schedule_type'], labelStyle, valueStyle, Icons.schedule, Colors.orange),
                    buildDetailWithIcon("مبلغ القرض", widget.loanData['loan_amount'], labelStyle, valueStyle, Icons.attach_money, Colors.green),
                    buildDetailWithIcon("عدد الأقساط", widget.loanData['repayment_periods'], labelStyle, valueStyle, Icons.format_list_numbered, Colors.blueGrey),
                    buildDetailWithIcon("المبلغ الشهري", widget.loanData['monthly_repayment_amount'], labelStyle, valueStyle, Icons.money, Colors.amber),
                    buildDetailWithIcon("مبلغ الصرف", widget.loanData['disbursed_amount'], labelStyle, valueStyle, Icons.account_balance_wallet, Colors.deepPurple),
                    buildDetailWithIcon("تاريخ الصرف", widget.loanData['disbursement_date'], labelStyle, valueStyle, Icons.date_range, Colors.cyan),
                    buildDetailWithIcon("تاريخ بدء السداد", widget.loanData['repayment_start_date'], labelStyle, valueStyle, Icons.event, Colors.pink),
                    buildDetailWithIcon("إجمالي المدفوع", widget.loanData['total_payment'], labelStyle, valueStyle, Icons.payments, Colors.red),
                    buildDetailWithIcon("الحالة", widget.loanData['status'], labelStyle, valueStyle, Icons.info, Colors.blue),
                    buildDetailWithIcon("تاريخ القيد", widget.loanData['posting_date'], labelStyle, valueStyle, Icons.event_available, Colors.teal),
                    buildDetailWithIcon("الشركة", widget.loanData['company'], labelStyle, valueStyle, Icons.business, Colors.brown),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("جدول الأقساط", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textDirection: TextDirection.rtl),
            const SizedBox(height: 10),
            ...?widget.loanData['accounts_details']?.map<Widget>((item) => buildInstallmentCard(item)).toList(),
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
    if (value == null || (value is String && value.trim().isEmpty)) return const SizedBox.shrink();

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

  Widget buildInstallmentCard(dynamic item) {
    Color borderColor = getRandomColor();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailWithIcon("تاريخ الدفع", item['payment_date'], const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), const TextStyle(fontSize: 12), Icons.calendar_today, Colors.teal),
          buildDetailWithIcon("المبلغ الأساسي", item['principal_amount'], const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), const TextStyle(fontSize: 12), Icons.attach_money, Colors.green),
          buildDetailWithIcon("مبلغ الفائدة", item['interest_amount'], const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), const TextStyle(fontSize: 12), Icons.percent, Colors.purple),
          buildDetailWithIcon("إجمالي الدفع", item['total_payment'], const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), const TextStyle(fontSize: 12), Icons.payments, Colors.blue),
          buildDetailWithIcon("الرصيد المتبقي", item['balance_loan_amount'], const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), const TextStyle(fontSize: 12), Icons.account_balance_wallet, Colors.redAccent),
        ],
      ),
    );
  }
}
