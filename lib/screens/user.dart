import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:group_planner_app/consts/utils.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    ScreenUtil.init(context, designSize: const Size(414, 896));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.only(top: 30),
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.jpg'),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    shape: BoxShape.circle),
                                child: InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: ScreenUtil().setSp(15),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          themeState.getDarkTheme
                              ? themeState.setDarkTheme = false
                              : themeState.setDarkTheme = true;
                        },
                        icon: Icon(
                          themeState.getDarkTheme
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          size: ScreenUtil().setSp(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Name',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(17),
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Mail',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(13),
                  fontWeight: themeState.getDarkTheme
                      ? FontWeight.w200
                      : FontWeight.w300),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     fixedSize: const Size(200, 40),
            //     primary: kPrimaryColor,
            //     shape: const RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(30))),
            //   ),
            //   onPressed: () {},
            //   child: Text(
            //     'Upgrade to PRO',
            //     style: TextStyle(
            //       fontSize: ScreenUtil().setSp(15),
            //       fontWeight: FontWeight.w400,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: [
                  ProfileListItem(
                    icon: IconlyLight.shield_done,
                    text: 'Privacy',
                    onPressed: () {},
                    isDarkTheme: themeState.getDarkTheme,
                  ),
                  // ProfileListItem(
                  //   icon: IconlyLight.time_circle,
                  //   text: 'Purchase History',
                  //   onPressed: () {},
                  //   isDarkTheme: themeState.getDarkTheme,
                  // ),
                  ProfileListItem(
                    icon: IconlyLight.discovery,
                    text: 'Help & Support',
                    onPressed: () {},
                    isDarkTheme: themeState.getDarkTheme,
                  ),
                  ProfileListItem(
                    icon: IconlyLight.setting,
                    text: 'Settings',
                    onPressed: () {},
                    isDarkTheme: themeState.getDarkTheme,
                  ),
                  ProfileListItem(
                    icon: IconlyLight.add_user,
                    text: 'Invite a Friend',
                    onPressed: () {},
                    isDarkTheme: themeState.getDarkTheme,
                  ),
                  ProfileListItem(
                    icon: IconlyLight.logout,
                    text: 'Logout',
                    onPressed: () {},
                    isDarkTheme: themeState.getDarkTheme,
                    hasNavgigation: false,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onPressed;
  final bool isDarkTheme;
  final bool hasNavgigation;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.isDarkTheme,
    this.hasNavgigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isDarkTheme ? Colors.grey[800] : Colors.white),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 25,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(17),
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Visibility(
                visible: hasNavgigation,
                child: const Icon(
                  IconlyLight.arrow_right_2,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
