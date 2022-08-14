import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:group_planner_app/consts/utils.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../consts/theme_manager.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool themeSelector = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    ScreenUtil.init(context, designSize: const Size(414, 896));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Column(
                  children: [
                    Stack(
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
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    themeSelector = true;
                                  });
                                },
                                icon: Icon(
                                  (theme.getTheme() == theme.lightTheme)
                                      ? Icons.light_mode_outlined
                                      : Icons.dark_mode_outlined,
                                ),
                              ),
                              Visibility(
                                visible: themeSelector,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          theme.setLightMode();
                                          setState(() {
                                            themeSelector = false;
                                          });
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.light_mode_outlined),
                                            Text(' Light')
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          theme.setDarkMode();
                                          setState(() {
                                            themeSelector = false;
                                          });
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.dark_mode_outlined),
                                            Text(' Dark')
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: const [
                                            Icon(Icons.computer_outlined),
                                            Text(' System')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 150,
                              ),
                              Text('Name', style: kTitleTextStyle),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('Mail', style: kCaptionTextStyle),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              // ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //     fixedSize: const Size(200, 40),
                              //     primary: Theme.of(context).primaryColor,
                              //     shape: const RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(30))),
                              //   ),
                              //   onPressed: () {},
                              //   child: Text('Upgrade to PRO',
                              //       style: kButtonTextStyle),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ProfileListItem(
                    icon: IconlyLight.shield_done,
                    text: 'Privacy',
                    onPressed: () {},
                  ),
                  // ProfileListItem(
                  //   icon: IconlyLight.time_circle,
                  //   text: 'Purchase History',
                  //   onPressed: () {},
                  // ),
                  ProfileListItem(
                    icon: IconlyLight.discovery,
                    text: 'Help & Support',
                    onPressed: () {},
                  ),
                  ProfileListItem(
                    icon: IconlyLight.setting,
                    text: 'Settings',
                    onPressed: () {},
                  ),
                  ProfileListItem(
                    icon: IconlyLight.add_user,
                    text: 'Invite a Friend',
                    onPressed: () {},
                  ),
                  ProfileListItem(
                    icon: IconlyLight.logout,
                    text: 'Logout',
                    onPressed: () {},
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
  final bool hasNavgigation;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.hasNavgigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).cardColor),
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
              Text(text,
                  style: kTitleTextStyle.copyWith(fontWeight: FontWeight.w500)),
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
