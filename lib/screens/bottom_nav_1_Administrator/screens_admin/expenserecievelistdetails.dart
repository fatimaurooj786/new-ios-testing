import 'package:flutter/material.dart';
import 'dart:math';
import '../../../widgets/colors.dart';

class Expenserecievelistdetails extends StatefulWidget {
  final dynamic paymentItem;

  const Expenserecievelistdetails({super.key, required this.paymentItem});

  @override
  _ExpenserecievelistdetailsState createState() =>
      _ExpenserecievelistdetailsState();
}

class _ExpenserecievelistdetailsState extends State<Expenserecievelistdetails>
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
    List accounts = widget.paymentItem['accounts_details'] ?? [];
    List taxes = widget.paymentItem['taxes_details'] ?? [];
    List advances = widget.paymentItem['advances'] ?? [];

    TextStyle labelStyle = const TextStyle(
        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black);
    TextStyle valueStyle =
        const TextStyle(fontSize: 12, color: Colors.black);

    Color randomLogoBorderColor = getRandomColor();
    Color randomCardBorderColor = getRandomColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل المصروف", textDirection: TextDirection.rtl),
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
                    buildDetailWithIcon("الحالة", widget.paymentItem['status'], labelStyle, valueStyle, Icons.info, Colors.blue),
                    buildDetailWithIcon("الموظف", widget.paymentItem['employee'], labelStyle, valueStyle, Icons.person_pin, Colors.green),
                    buildDetailWithIcon("اسم الموظف", widget.paymentItem['employee_name'], labelStyle, valueStyle, Icons.person, Colors.teal),
                    buildDetailWithIcon("حالة الموافقة", widget.paymentItem['approval_status'], labelStyle, valueStyle, Icons.verified, Colors.purple),
                    buildDetailWithIcon("إجمالي المبلغ المعتمد", widget.paymentItem['total_sanctioned_amount'], labelStyle, valueStyle, Icons.attach_money, Colors.orange),
                    buildDetailWithIcon("الإجمالي النهائي", widget.paymentItem['grand_total'], labelStyle, valueStyle, Icons.calculate, Colors.redAccent),
                    buildDetailWithIcon("إجمالي الضرائب والرسوم", widget.paymentItem['total_taxes_and_charges'], labelStyle, valueStyle, Icons.receipt, Colors.deepPurple),
                    buildDetailWithIcon("إجمالي المبلغ المطالب به", widget.paymentItem['total_claimed_amount'], labelStyle, valueStyle, Icons.money, Colors.brown),
                    buildDetailWithIcon("إجمالي السلفة", widget.paymentItem['total_advance_amount'], labelStyle, valueStyle, Icons.credit_card, Colors.cyan),
                    buildDetailWithIcon("إجمالي المبلغ المسترد", widget.paymentItem['total_amount_reimbursed'], labelStyle, valueStyle, Icons.wallet, Colors.indigo),
                    buildDetailWithIcon("تاريخ النشر", widget.paymentItem['posting_date'], labelStyle, valueStyle, Icons.date_range, Colors.red),
                    buildDetailWithIcon("الشركة", widget.paymentItem['company'], labelStyle, valueStyle, Icons.business, Colors.green),
                    buildDetailWithIcon("الحساب المستحق الدفع", widget.paymentItem['payable_account'], labelStyle, valueStyle, Icons.account_balance_wallet, Colors.blueGrey),
                    buildDetailWithIcon("مركز التكلفة", widget.paymentItem['cost_center'], labelStyle, valueStyle, Icons.account_tree, Colors.amber),

                    if (accounts.isNotEmpty) ...[
                      const SizedBox(height: 35),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "  تفاصيل الحسابات :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: randomCardBorderColor),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var account in accounts) ...[
                              buildDetailWithIcon("تاريخ المصروف", account['expense_date'], labelStyle, valueStyle, Icons.event, Colors.teal),
                              buildDetailWithIcon("نوع المصروف", account['expense_type'], labelStyle, valueStyle, Icons.category, Colors.pink),
                              buildDetailWithIcon("المبلغ", account['amount'], labelStyle, valueStyle, Icons.attach_money, Colors.green),
                              buildDetailWithIcon("الحساب الافتراضي", account['default_account'], labelStyle, valueStyle, Icons.account_balance, Colors.orange),
                              buildDetailWithIcon("الوصف", account['description'], labelStyle, valueStyle, Icons.description, Colors.deepPurple),
                              const SizedBox(height: 30),
                            ],
                          ],
                        ),
                      ),
                    ],

                    if (taxes.isNotEmpty) ...[
                      const SizedBox(height: 35),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          " تفاصيل الضرائب  :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: randomCardBorderColor),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var tax in taxes) ...[
                              buildDetailWithIcon("الحساب", tax['account_head'], labelStyle, valueStyle, Icons.account_tree, Colors.orange),
                              buildDetailWithIcon("الإجمالي", tax['total'], labelStyle, valueStyle, Icons.attach_money, Colors.green),
                              const SizedBox(height: 30),
                            ],
                          ],
                        ),
                      ),
                    ],

                    if (advances.isNotEmpty) ...[
                      const SizedBox(height: 35),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "  تفاصيل السلف :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColors.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: randomCardBorderColor),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var advance in advances) ...[
                              buildDetailWithIcon("رقم السلفة", advance['employee_advance'], labelStyle, valueStyle, Icons.confirmation_number, Colors.blue),
                              buildDetailWithIcon("تاريخ السلفة", advance['posting_date'], labelStyle, valueStyle, Icons.event, Colors.orange),
                              buildDetailWithIcon("المبلغ المدفوع", advance['advance_paid'], labelStyle, valueStyle, Icons.attach_money, Colors.green),
                              buildDetailWithIcon("المبلغ غير المطالب به", advance['unclaimed_amount'], labelStyle, valueStyle, Icons.money_off, Colors.redAccent),
                              buildDetailWithIcon("المبلغ المخصص", advance['allocated_amount'], labelStyle, valueStyle, Icons.money, Colors.indigo),
                              const SizedBox(height: 30),
                            ],
                          ],
                        ),
                      ),
                    ],
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
    if (value == null || value.toString().trim().isEmpty || value == 'N/A') {
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
          Text(
            "$label :",
            style: labelStyle,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$value",
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
