import 'package:flutter/material.dart';
import 'dart:math';
import '../../../widgets/colors.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final dynamic paymentItem;

  const PaymentDetailsScreen({super.key, required this.paymentItem});

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen>
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

    TextStyle labelStyle = const TextStyle(
        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black);
    TextStyle valueStyle =
        const TextStyle(fontSize: 12, color: Colors.black);

    Color randomLogoBorderColor = getRandomColor();
    Color randomCardBorderColor = getRandomColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الدفع"),
        backgroundColor: MyColors.color,
         automaticallyImplyLeading: false, // Prevents the default back button
          leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  color: Colors.white, // Set the back button color to white
  onPressed: () {
    Navigator.pop(context); // This will go back to the previous screen
  },
),
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
                    buildDetailWithIcon("حالة سير العمل", widget.paymentItem['workflow_state'], labelStyle, valueStyle, Icons.work, Colors.blue),
                    buildDetailWithIcon("نوع الطرف", widget.paymentItem['party_type'], labelStyle, valueStyle, Icons.people, Colors.green),
                    buildDetailWithIcon("المبلغ المدفوع", widget.paymentItem['paid_amount'], labelStyle, valueStyle, Icons.payment, Colors.orange),
                    buildDetailWithIcon("الشركة", widget.paymentItem['company'], labelStyle, valueStyle, Icons.business, Colors.purple),
                    buildDetailWithIcon("الطرف", widget.paymentItem['party'], labelStyle, valueStyle, Icons.account_balance, Colors.teal),
                    buildDetailWithIcon("تاريخ النشر", widget.paymentItem['posting_date'], labelStyle, valueStyle, Icons.date_range, Colors.red),
                    buildDetailWithIcon("طريقة الدفع", widget.paymentItem['mode_of_payment'], labelStyle, valueStyle, Icons.monetization_on, Colors.amber),
                    buildDetailWithIcon("الحساب المدفوع منه", widget.paymentItem['account_paid_from'], labelStyle, valueStyle, Icons.account_balance_wallet, Colors.cyan),
                    buildDetailWithIcon("تاريخ البدء", widget.paymentItem['start_date'], labelStyle, valueStyle, Icons.date_range, Colors.blueAccent),
                    buildDetailWithIcon("تاريخ الانتهاء", widget.paymentItem['end_date'], labelStyle, valueStyle, Icons.date_range, Colors.deepPurple),
                    buildDetailWithIcon("الملاحظات", widget.paymentItem['remarks'], labelStyle, valueStyle, Icons.comment, Colors.brown),
                    const SizedBox(height: 35),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        " : تفاصيل الحسابات ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
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
                            buildDetailWithIcon("الحساب", account['account'], labelStyle, valueStyle, Icons.account_circle, Colors.indigo),
                            buildDetailWithIcon("المبلغ", account['amount'], labelStyle, valueStyle, Icons.attach_money, Colors.green),
                            buildDetailWithIcon("المستفيد", account['beneficiaries_name'], labelStyle, valueStyle, Icons.person, Colors.red),
                            buildDetailWithIcon("رمز العنصر", account['item_code'], labelStyle, valueStyle, Icons.code, Colors.blue),
                            buildDetailWithIcon("طلب المساعدة", account['help_request'], labelStyle, valueStyle, Icons.help, Colors.orange),
                            const SizedBox(height: 50),
                          ],
                        ],
                      ),
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

  Widget buildDetailWithIcon(
  String label,
  dynamic value,
  TextStyle labelStyle,
  TextStyle valueStyle,
  IconData icon,
  Color iconColor,
) {
  if (value == null || value.toString().trim().isEmpty || value == 'N/A') {
    return const SizedBox.shrink(); // Hide row if value is empty or "N/A"
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Row(
      textDirection: TextDirection.rtl, // Aligns RTL (Arabic-friendly)
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
