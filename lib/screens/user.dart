import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:group_planner_app/services/utils.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
  String? _email;
  String? _name;
  File? _image;
  String _imageUrl = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      _email = userDoc.get('email');
      _name = userDoc.get('username');
      _imageUrl = userDoc.get('profilePictureUrl');
    } catch (error) {
      GlobalMethods.dialog(
        context: context,
        title: 'On snap!',
        message: '$error',
        contentType: ContentType.failure,
      );
      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      GlobalMethods.dialog(
          context: context,
          title: 'Oh snap!',
          message: '${error.message}',
          contentType: ContentType.failure);
    } catch (error) {
      GlobalMethods.dialog(
        context: context,
        title: 'Oh snap!',
        message: '$error',
        contentType: ContentType.failure,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                      : const CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/group-planner-d4826.appspot.com/o/Profile.jpg?alt=media&token=e204d44b-afbe-4f95-a928-1e589ca75712'),
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
                                    width: 115,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            theme.setLightMode();
                                            // setState(() {
                                            //   themeSelector = false;
                                            // });
                                          },
                                          child: FittedBox(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.light_mode_outlined,
                                                  color: lightMode,
                                                  size: 25,
                                                ),
                                                Text(
                                                  ' Light',
                                                  style:
                                                      kTitleTextStyle.copyWith(
                                                    color: lightMode,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            theme.setDarkMode();
                                            // setState(() {
                                            //   themeSelector = false;
                                            // });
                                          },
                                          child: FittedBox(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.dark_mode_outlined,
                                                  size: 25,
                                                  color: darkMode,
                                                ),
                                                Text(
                                                  ' Dark',
                                                  style:
                                                      kTitleTextStyle.copyWith(
                                                          color: darkMode,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            theme.setSystemMode();
                                          },
                                          child: FittedBox(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.computer_outlined,
                                                  size: 25,
                                                  color: systemMode,
                                                ),
                                                Text(
                                                  ' System',
                                                  style:
                                                      kTitleTextStyle.copyWith(
                                                    color: systemMode,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                  height: 148,
                                ),
                                Text(_name ?? 'User', style: kTitleTextStyle),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(_email ?? '', style: kCaptionTextStyle),
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
                      onPressed: (context) async {
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
                          GlobalMethods.dialog(
                            title: 'Oh Snap!',
                            message: '${error.message}',
                            context: context,
                            contentType: ContentType.failure,
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        } catch (error) {
                          GlobalMethods.dialog(
                            title: 'Oh Snap!',
                            message: '$error',
                            context: context,
                            contentType: ContentType.failure,
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
          onPressed(context);
        },
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
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
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
