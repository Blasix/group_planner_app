//
// TODO: vervangen door https://pub.dev/packages/flutter_floating_bottom_bar
//

import 'package:flutter/material.dart';
import 'package:group_planner_app/screens/user.dart';
import 'package:iconly/iconly.dart';

import 'home.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int selectedIndex = 0;
  final List pages = [const HomeScreen(), const UserScreen()];

  void _selectedPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color(0xFFFFC107),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          currentIndex: selectedIndex,
          onTap: _selectedPage,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:
                  Icon(selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 1
                  ? IconlyBold.profile
                  : IconlyLight.profile),
              label: "User",
            ),
          ],
        ));
  }
}
