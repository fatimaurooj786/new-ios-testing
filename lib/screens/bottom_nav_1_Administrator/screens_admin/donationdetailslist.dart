import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/paymentrecievewithdonorsdata.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../../widgets/colors.dart';

class Donationdetailslist extends StatefulWidget {
  final dynamic paymentItem;

  const Donationdetailslist({super.key, required this.paymentItem});

  @override
  State<Donationdetailslist> createState() => _DonationdetailslistState();
}

class _DonationdetailslistState extends State<Donationdetailslist>
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

            // 🟢 New Button to navigate with data
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text("إنشاء إيصال دفع", textDirection: TextDirection.rtl, style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.color,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Paymentrecievewithdonorsdata(data: widget.paymentItem),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

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
                    buildDetailWithIcon(
                      "نوع التبرع",
                      widget.paymentItem['donation_type'],
                      labelStyle,
                      valueStyle,
                      Icons.category,
                      Colors.deepOrange,
                    ),
                    buildDetailWithIcon(
                      "المتبرع",
                      widget.paymentItem['donor'],
                      labelStyle,
                      valueStyle,
                      Icons.person,
                      Colors.green,
                    ),
                    buildDetailWithIcon(
                      "اسم المتبرع",
                      widget.paymentItem['donor_name'],
                      labelStyle,
                      valueStyle,
                      Icons.person_outline,
                      Colors.teal,
                    ),
                    buildDetailWithIcon(
                      "الموظف",
                      widget.paymentItem['employee'],
                      labelStyle,
                      valueStyle,
                      Icons.person_pin,
                      Colors.blue,
                    ),
                    buildDetailWithIcon(
                      "المشروع",
                      widget.paymentItem['project'],
                      labelStyle,
                      valueStyle,
                      Icons.business_center,
                      Colors.purple,
                    ),
                    buildDetailWithIcon(
                      "الشركة",
                      widget.paymentItem['company'],
                      labelStyle,
                      valueStyle,
                      Icons.business,
                      Colors.brown,
                    ),
                    buildDetailWithIcon(
                      "التاريخ",
                      widget.paymentItem['date'],
                      labelStyle,
                      valueStyle,
                      Icons.date_range,
                      Colors.red,
                    ),
                    buildDetailWithIcon(
                      "ملاحظات",
                      widget.paymentItem['remarks'],
                      labelStyle,
                      valueStyle,
                      Icons.note,
                      Colors.indigo,
                    ),
                    buildDetailWithIcon(
                      "حساب المبلغ",
                      widget.paymentItem['account_for_amount'],
                      labelStyle,
                      valueStyle,
                      Icons.account_balance_wallet,
                      Colors.cyan,
                    ),
                    buildDetailWithIcon(
                      "المبلغ",
                      widget.paymentItem['amount'],
                      labelStyle,
                      valueStyle,
                      Icons.attach_money,
                      Colors.orange,
                    ),
                    buildDetailWithIcon(
                      "اسم المستند",
                      widget.paymentItem['document_name'],
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

  Widget buildDetailWithIcon(
    String label,
    dynamic value,
    TextStyle labelStyle,
    TextStyle valueStyle,
    IconData icon,
    Color iconColor,
  ) {
    // Hide field if value is null, empty, zero (for amount), or 'N/A'
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
