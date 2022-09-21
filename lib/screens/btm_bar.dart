import 'package:flutter/material.dart';
import 'package:group_planner_app/providers/member_provider.dart';
import 'package:group_planner_app/screens/agenda.dart';
import 'package:group_planner_app/screens/team.dart';
import 'package:group_planner_app/screens/user.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../providers/team_provider.dart';
import 'home.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int selectedIndex = 0;
  final List pages = [
    const HomeScreen(),
    const AgendaScreen(),
    const TeamScreen(),
    const UserScreen(),
  ];

  void _selectedPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    final userProvider = Provider.of<MemberProvider>(context, listen: false);
    userProvider.fetchCurrentUser();

    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    teamProvider.fetchTeams();
    teamProvider.fetchSelectedTeam();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
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
                  ? IconlyBold.calendar
                  : IconlyLight.calendar),
              label: "Agenda",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  selectedIndex == 2 ? IconlyBold.user_3 : IconlyLight.user_1),
              label: "Team",
            ),
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 3
                  ? IconlyBold.profile
                  : IconlyLight.profile),
              label: "User",
            ),
          ],
        ));
  }
}
