import 'dart:async';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/Donation_list.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/employeeadvancelist.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/expenseclaimlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chart_harakia/widgets/colors.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/payment_pay_list.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/paymentrecievelist.dart';

class HomeScreenContentAdmin extends StatefulWidget {
  const HomeScreenContentAdmin({super.key});

  @override
  State<HomeScreenContentAdmin> createState() => _HomeScreenContentAdminState();
}

class _HomeScreenContentAdminState extends State<HomeScreenContentAdmin> with TickerProviderStateMixin {
  Future<String>? fullNameFuture;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _timer;

  final double fontSize = 24;

  @override
  void initState() {
    super.initState();
    fullNameFuture = _extractFullName();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _animationController.forward(from: 0.0);
      }
    });
  }

  Future<String> _extractFullName() async {
    final prefs = await SharedPreferences.getInstance();
    String? cookies = prefs.getString('erpnext_cookie');

    if (cookies != null) {
      List<String> cookieParts = cookies.split(';');
      for (var part in cookieParts) {
        part = part.trim();
        if (part.contains('full_name=')) {
          int index = part.indexOf('full_name=');
          String fullNameEncoded = part.substring(index + 'full_name='.length);
          return Uri.decodeComponent(fullNameEncoded);
        }
      }
    }

    return 'Admin';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            backgroundColor: MyColors.color,
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: FutureBuilder<String>(
                future: fullNameFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: Text(
                              snapshot.data ?? "الرئيسية",
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              CardButton(
                label: "قائمة دفع المدفوعات",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentPayListScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CardButton(
                label: "استلام المدفوعات",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentRecieveScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CardButton(
                label: "قائمة مطالبات النفقات",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Expenseclaimlist()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CardButton(
                label: "قائمة التبرعات",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DonationList()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CardButton(
                label: "قائمة السُلف للموظفين",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Employeeadvancelist()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const CardButton({super.key, required this.label, required this.onTap});

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  double scale = 1.0;
  Color cardColor = Colors.white;
  Color arrowColor = MyColors.color;
  Color textColor = MyColors.color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          scale = 1.07;
          cardColor = MyColors.color;
          arrowColor = Colors.white;
          textColor = Colors.white;
        });
      },
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 200));
        widget.onTap();
        setState(() {
          scale = 1.0;
          cardColor = Colors.white;
          arrowColor = MyColors.color;
          textColor = MyColors.color;
        });
      },
      onTapCancel: () {
        setState(() {
          scale = 1.0;
          cardColor = Colors.white;
          arrowColor = MyColors.color;
          textColor = MyColors.color;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(color: MyColors.color, width: 2),
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 80,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: arrowColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, color: arrowColor, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
