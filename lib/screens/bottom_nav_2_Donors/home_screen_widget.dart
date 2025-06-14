import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:chart_harakia/widgets/colors.dart';

// Dummy Screens – Replace with your actual screens
class BranchesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("الفروع", style: TextStyle(fontSize: 24)));
  }
}

class ServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("الخدمات", style: TextStyle(fontSize: 24)));
  }
}

class HomeScreenContentDoners extends StatelessWidget {
  const HomeScreenContentDoners({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("الرئيسية", style: TextStyle(fontSize: 24)));
  }
}

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("المحفظة", style: TextStyle(fontSize: 24)));
  }
}

class ProfileScreenDoners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("الملف الشخصي", style: TextStyle(fontSize: 24)));
  }
}

class HomeScreenDoners extends StatefulWidget {
  const HomeScreenDoners({super.key});

  @override
  State<HomeScreenDoners> createState() => _HomeScreenDonersState();
}

class _HomeScreenDonersState extends State<HomeScreenDoners> {
  int currentIndex = 2; // Set Home as center and default screen
  late PageController _pageController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          BranchesScreen(),                    // index 0
          ServicesScreen(),                    // index 1
          const HomeScreenContentDoners(),     // index 2 (center)
          WalletScreen(),                      // index 3
          ProfileScreenDoners(),               // index 4
        ],
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: SalomonBottomBar(
        selectedItemColor: MyColors.color,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.storefront),
            title: const Text("الفروع"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.design_services),
            title: const Text("الخدمات"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("الرئيسية"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.account_balance_wallet),
            title: const Text("المحفظة"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("الملف الشخصي"),
          ),
        ],
      ),
    );
  }
}
