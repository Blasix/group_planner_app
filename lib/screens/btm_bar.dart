import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:group_planner_app/screens/agenda.dart';
import 'package:group_planner_app/screens/team.dart';
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
  final List pages = [
    // const HomeScreen(),
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
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    //TODO: Change to real Ad ID
    String bannerAdId = platform == TargetPlatform.iOS
        ? "ca-app-pub-3940256099942544/2934735716"
        : "ca-app-pub-3940256099942544/6300978111";
    final BannerAd myBanner = BannerAd(
      adUnitId: bannerAdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final Container adContainer = Container(
      alignment: Alignment.center,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
      child: adWidget,
    );

    return Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: Container(
          color: Theme.of(context).canvasColor,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BottomNavigationBar(
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Theme.of(context).primaryColor,
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  currentIndex: selectedIndex,
                  onTap: _selectedPage,
                  items: <BottomNavigationBarItem>[
                    // BottomNavigationBarItem(
                    //   icon: Icon(selectedIndex == 0
                    //       ? IconlyBold.home
                    //       : IconlyLight.home),
                    //   label: "Home",
                    // ),
                    BottomNavigationBarItem(
                      icon: Icon(selectedIndex == 1
                          ? IconlyBold.calendar
                          : IconlyLight.calendar),
                      label: "Agenda",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(selectedIndex == 2
                          ? IconlyBold.user_3
                          : IconlyLight.user_1),
                      label: "Team",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(selectedIndex == 3
                          ? IconlyBold.profile
                          : IconlyLight.profile),
                      label: "User",
                    ),
                  ],
                ),
                adContainer,
              ],
            ),
          ),
        ));
  }
}
