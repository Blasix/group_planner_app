import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconly/iconly.dart';

import '../../consts/firebase_consts.dart';
import '../../services/global_methods.dart';
import 'auth/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GlobalMethods.profileListItem(
          context: context,
          icon: IconlyLight.logout,
          text: AppLocalizations.of(context)!.logout,
          onPressed: (context) async {
            GlobalMethods.confirm(
              context: context,
              message: 'Do you want to logout',
              onTap: () async {
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
                } catch (error) {
                  GlobalMethods.dialog(
                    title: 'Oh Snap!',
                    message: '$error',
                    context: context,
                    contentType: ContentType.failure,
                  );
                }
              },
            );
          },
          hasNavgigation: false,
        ),
      ),
    );
  }
}
