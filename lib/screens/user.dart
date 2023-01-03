import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:group_planner_app/models/member_model.dart';
import 'package:group_planner_app/providers/member_provider.dart';
import 'package:group_planner_app/screens/inner/user/help_support.dart';
import 'package:group_planner_app/screens/inner/user/privacy.dart';
import 'package:group_planner_app/screens/inner/user/settings.dart';
import 'package:group_planner_app/services/utils.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../consts/firebase_consts.dart';
import '../consts/theme_manager.dart';
import '../services/global_methods.dart';
import 'auth/login.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isLoading = false;
  bool themeSelector = false;
  final User? user = authInstance.currentUser;
  // String? _email;
  // String? _name;
  String _imageUrl = '';

  // @override
  // void initState() {
  //   Future.delayed(const Duration(microseconds: 5), () async {
  //     final memberProvider = Provider.of<MemberProvider>(context);
  //     MemberModel? member = memberProvider.getCurrentMember;
  //     setState(() {
  //       _imageUrl = memberProvider.getCurrentMember!.pictureURL;
  //     });
  //   });

  //   super.initState();
  // }

  // Future<void> getUserData() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   if (user == null) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     return;
  //   }
  //   try {
  //     String uid = user!.uid;
  //     final DocumentSnapshot userDoc =
  //         await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //     _email = userDoc.get('email');
  //     _name = userDoc.get('username');
  //     _imageUrl = userDoc.get('profilePictureUrl');
  //   } catch (error) {
  //     GlobalMethods.dialog(
  //       context: context,
  //       title: 'Oh snap!',
  //       message: '$error',
  //       contentType: ContentType.failure,
  //     );
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future getImage(imageSource) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final image = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75,
      );
      String uid = user!.uid;
      Reference ref =
          FirebaseStorage.instance.ref().child('ProfilePics/$uid.jpg');
      if (image == null) return;
      await ref.putFile(File(image.path));
      ref.getDownloadURL().then((value) async {
        setState(() {
          _imageUrl = value;
        });
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profilePictureUrl': value,
        });
      });
    } on PlatformException catch (error) {
      GlobalMethods.dialogFailure(
        context: context,
        title: 'Oh snap!',
        message: '${error.message}',
      );
    } catch (error) {
      GlobalMethods.dialogFailure(
        context: context,
        title: 'Oh snap!',
        message: '$error',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    MemberModel member = memberProvider.getCurrentMember;
    Color lightMode = Theme.of(context).colorScheme.primary;
    Color darkMode = Theme.of(context).colorScheme.primary;
    Color systemMode = Theme.of(context).colorScheme.primary;
    bool isDarkTheme =
        (Theme.of(context).colorScheme.primary == Colors.white) ? true : false;
    final theme = Provider.of<ThemeNotifier>(context);
    if (theme.getTheme() == ThemeMode.light) {
      setState(() {
        lightMode = Theme.of(context).primaryColor;
      });
    }
    if (theme.getTheme() == ThemeMode.dark) {
      setState(() {
        darkMode = Theme.of(context).primaryColor;
      });
    }
    if (theme.getTheme() == ThemeMode.system) {
      setState(() {
        systemMode = Theme.of(context).primaryColor;
      });
    }
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: SafeArea(
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
                                  _imageUrl != ''
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              NetworkImage(_imageUrl),
                                        )
                                      : member.pictureURL != ''
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  member.pictureURL),
                                            )
                                          : const CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  'https://firebasestorage.googleapis.com/v0/b/group-planner-d4826.appspot.com/o/Profile.jpg?alt=media&token=3dc7bc58-3bf3-4548-a2d5-09a3027190db'),
                                            ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 34,
                                      width: 34,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle),
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                ),
                                              ),
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SafeArea(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          getImage(ImageSource
                                                              .gallery);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                IconlyLight
                                                                    .image_2,
                                                                size: 30,
                                                              ),
                                                              Text(
                                                                ' Photo library',
                                                                style:
                                                                    kTitleTextStyle
                                                                        .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          getImage(ImageSource
                                                              .camera);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                IconlyLight
                                                                    .camera,
                                                                size: 30,
                                                              ),
                                                              Text(
                                                                ' Camera',
                                                                style:
                                                                    kTitleTextStyle
                                                                        .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          size: 20,
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
                                    themeSelector
                                        ? setState(() {
                                            themeSelector = false;
                                          })
                                        : setState(() {
                                            themeSelector = true;
                                          });
                                  },
                                  icon: Icon(
                                    isDarkTheme
                                        ? Icons.dark_mode_outlined
                                        : Icons.light_mode_outlined,
                                    size: 32,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {
                                            theme.setLightMode();
                                            // setState(() {
                                            //   themeSelector = false;
                                            // });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: FittedBox(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.light_mode_outlined,
                                                    color: lightMode,
                                                    size: 22,
                                                  ),
                                                  Text(
                                                    ' Light',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: lightMode,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {
                                            theme.setDarkMode();
                                            // setState(() {
                                            //   themeSelector = false;
                                            // });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: FittedBox(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.dark_mode_outlined,
                                                    color: darkMode,
                                                    size: 22,
                                                  ),
                                                  Text(
                                                    ' Dark',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: darkMode,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {
                                            theme.setSystemMode();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: FittedBox(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.computer_outlined,
                                                    color: systemMode,
                                                    size: 22,
                                                  ),
                                                  Text(
                                                    ' System',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: systemMode,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
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
                                  height: 148,
                                ),
                                Text(member.name, style: kTitleTextStyle),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(member.email, style: kCaptionTextStyle),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //     fixedSize: const Size(200, 40),
                                //     backgroundColor:
                                //         Theme.of(context).primaryColor,
                                //     shape: const RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(30))),
                                //   ),
                                //   onPressed: () {},
                                //   child: const Text(
                                //     'Upgrade to PRO',
                                //     style: TextStyle(
                                //       fontSize: 15,
                                //       fontWeight: FontWeight.w400,
                                //       color: Colors.black,
                                //     ),
                                //   ),
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
                  physics: const BouncingScrollPhysics(),
                  children: [
                    GlobalMethods.profileListItem(
                        context: context,
                        icon: IconlyLight.shield_done,
                        text: AppLocalizations.of(context)!.privacy,
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyScreen(),
                            ),
                          );
                        }),
                    // ProfileListItem(
                    //   icon: IconlyLight.time_circle,
                    //   text: 'Purchase History',
                    //   onPressed: () {},
                    // ),
                    GlobalMethods.profileListItem(
                      context: context,
                      icon: IconlyLight.discovery,
                      text: AppLocalizations.of(context)!.helpSupport,
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),
                    GlobalMethods.profileListItem(
                      context: context,
                      icon: IconlyLight.setting,
                      text: AppLocalizations.of(context)!.settings,
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    GlobalMethods.profileListItem(
                      context: context,
                      icon: IconlyLight.add_user,
                      text: AppLocalizations.of(context)!.inviteAFriend,
                      onPressed: (context) {},
                    ),
                    GlobalMethods.profileListItem(
                      context: context,
                      icon: IconlyLight.logout,
                      text: AppLocalizations.of(context)!.logout,
                      onPressed: (context) async {
                        GlobalMethods.confirm(
                          context: context,
                          message: 'Do you want to logout',
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await authInstance.signOut();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            } on FirebaseAuthException catch (error) {
                              GlobalMethods.dialogFailure(
                                title: 'Oh Snap!',
                                message: '${error.message}',
                                context: context,
                              );
                              setState(() {
                                _isLoading = false;
                              });
                            } catch (error) {
                              GlobalMethods.dialogFailure(
                                title: 'Oh Snap!',
                                message: '$error',
                                context: context,
                              );
                              setState(() {
                                _isLoading = false;
                              });
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                        );
                      },
                      hasNavgigation: false,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
