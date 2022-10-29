import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../services/global_methods.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Language settings'),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            GlobalMethods.profileListItem(
              context: context,
              icon: Icons.language,
              text: AppLocalizations.of(context)!.language,
              onPressed: (context) {},
              hasNavgigation: false,
            ),
          ],
        ));
  }
}
