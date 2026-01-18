import 'package:blooddonation/home_screen.dart';
import 'package:blooddonation/profile.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  PageController pageController = PageController();
  int index = 0;

  final List<BottomNavigationBarItem> bottomNavItemList = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '',
    ),
    // const BottomNavigationBarItem(
    //   icon: Icon(Icons.volunteer_activism_outlined), // Donate/Request icon
    //   label: '',
    // ),
    // const BottomNavigationBarItem(
    //   icon: Icon(Icons.location_on_outlined), // Nearby
    //   label: '',
    // ),
    // const BottomNavigationBarItem(
    //   icon: Icon(Icons.notifications_outlined),
    //   label: '',
    // ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: '',
    ),
  ];

  final List<Widget> pages =  [
    HomePage(),
    // DonateRequestPage(),
    // NearbyCentersPage(),
    // notificationPage(),
  ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: (value) {
          setState(() {
            index = value;
          });
        },
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashFactory: NoSplash.splashFactory,
        ),
        child: BottomNavigationBar(
          items: bottomNavItemList,
          elevation: 2,
          currentIndex: index,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.red, // you can use a custom color too
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (value) {
            setState(() {
              index = value;
              pageController.jumpToPage(value);
            });
          },
        ),
      ),
    );
  }
}
