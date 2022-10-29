import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../services/global_methods.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Help & Support'),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            GlobalMethods.profileListItem(
              context: context,
              icon: IconlyLight.send,
              text: 'Send bug report',
              onPressed: (context) {},
            ),
            GlobalMethods.profileListItem(
              context: context,
              icon: Icons.list,
              text: 'Copyright',
              onPressed: (context) {},
            ),
            GlobalMethods.profileListItem(
              context: context,
              icon: Icons.question_mark_outlined,
              text: 'FAQ',
              onPressed: (context) {},
            ),
            GlobalMethods.profileListItem(
              context: context,
              icon: IconlyLight.ticket_star,
              text: 'Groep planner tester',
              onPressed: (context) {},
            ),
          ],
        ));
  }
}
