import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:group_planner_app/widgets/agenda/events.dart';
import 'package:iconly/iconly.dart';

import '../../consts/firebase_consts.dart';
import '../../services/global_methods.dart';
import '../services/utils.dart';
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
        child: Column(
          children: [
            //temp layout
            const Text("News", style: TextStyle(fontSize: 30)),
            const Text("new agenda shit (dus dan zo een progress balk en shit"),
            const EventsWidget(),
            const Text("new users"),
            Container(
              height: 55,
              margin: const EdgeInsets.symmetric(horizontal: 40)
                  .copyWith(bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).cardColor),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/group-planner-d4826.appspot.com/o/Profile.jpg?alt=media&token=e204d44b-afbe-4f95-a928-1e589ca75712'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text("user",
                          style: kTitleTextStyle.copyWith(
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.red),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("New", style: kCaptionTextStyle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Text("inspireation?!?", style: TextStyle(fontSize: 30)),
            const Text("patch notes", style: TextStyle(fontSize: 30)),
            const Spacer(),
            GlobalMethods.profileListItem(
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
                      GlobalMethods.dialogFailure(
                        message: '${error.message}',
                        context: context,
                      );
                    } catch (error) {
                      GlobalMethods.dialogFailure(
                        message: '$error',
                        context: context,
                      );
                    }
                  },
                );
              },
              hasNavgigation: false,
            ),
          ],
        ),
      ),
    );
  }
}
