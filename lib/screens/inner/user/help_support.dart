import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          title: Text(AppLocalizations.of(context)!.helpSupport),
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
              text: AppLocalizations.of(context)!.sendBugReport,
              onPressed: (context) {},
            ),
            GlobalMethods.profileListItem(
              context: context,
              icon: Icons.list,
              text: AppLocalizations.of(context)!.copyright,
              onPressed: (context) {},
            ),
            GlobalMethods.profileListItem(
              context: context,
              icon: Icons.question_mark_outlined,
              text: AppLocalizations.of(context)!.faq,
              onPressed: (context) {},
            ),
            GlobalMethods.profileListItem(
              context: context,
              icon: IconlyLight.ticket_star,
              text: AppLocalizations.of(context)!.becomeATester,
              onPressed: (context) {},
            ),
          ],
        ));
  }
}
