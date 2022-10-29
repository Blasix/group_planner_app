import 'package:flutter/material.dart';
import 'package:group_planner_app/screens/inner/user/settings/language.dart';
import 'package:iconly/iconly.dart';

import '../../../services/global_methods.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Setings'),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            GlobalMethods.profileListItem(
              context: context,
              icon: IconlyLight.notification,
              text: 'Push notifications',
              onPressed: (context) {},
            ),
            GlobalMethods.profileListItem(
              context: context,
              icon: Icons.language,
              text: 'Language',
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageScreen(),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
