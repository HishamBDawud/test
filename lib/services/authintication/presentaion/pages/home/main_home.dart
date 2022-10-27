import 'package:cleanapp/services/authintication/presentaion/pages/home/homePage/home_page_screen.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/home/notification/notification_screen.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/home/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../core/ui_constants/colors.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.jumpToPage(index);
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
        children: const <Widget>[
          HomePageScreen(),
          NotificationScreen(),
          ProfileScreen()
        ],
        onPageChanged: (page) {
          setState(() {
            selectedIndex = page;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 16,
        backgroundColor: third_color,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_active,
              size: 20,
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 20,
            ),
            label: "Profile",
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: primary_color,
        onTap: onTap,
      ),
    );
  }
}
