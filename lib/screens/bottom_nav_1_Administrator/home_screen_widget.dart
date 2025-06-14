import 'package:flutter/material.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/home.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/profile.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/expenseClaim.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/paymentRecievecreate.dart';
import 'package:chart_harakia/screens/bottom_nav_1_Administrator/screens_admin/paymentpaycreate.dart';
import 'package:chart_harakia/widgets/colors.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({super.key});

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  int currentIndex = 2;
  late PageController _pageController;

  final List<Widget> _pages = [
    PaymentPayScreen(),
    PaymentRecieveScreen(),
    HomeScreenContentAdmin(),
   ExpenseClaimScreen(),
    ProfileScreenAdmin(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Add this line
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
      ),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentIndex == 2 ? MyColors.color : Colors.white,
          border: Border.all(
            color: MyColors.color,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          onPressed: () => _onTabTapped(2),
          child: Icon(
            Icons.home,
            color: currentIndex == 2 ? Colors.white : MyColors.color,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(Icons.payment_sharp, "دفع الدفعة", 0),
              _buildNavItem(Icons.wallet_giftcard, "استلام دفعة", 1),
              const SizedBox(width: 40), // Space for FAB (home icon stays fixed in position)
              _buildNavItem(Icons.work, "مطالبة بمصاريف", 3),
              _buildNavItem(Icons.person, "الخروج", 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? MyColors.color : Colors.black,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? MyColors.color : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
