import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../consts/firebase_consts.dart';
import '../../../providers/member_provider.dart';
import '../../../providers/team_provider.dart';
import '../../../services/global_methods.dart';
import '../../auth/login.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.privacy),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            GlobalMethods.profileListItem(
              context: context,
              icon: IconlyLight.delete,
              text: AppLocalizations.of(context)!.deleteAccount,
              onPressed: (context) {
                GlobalMethods.confirm(
                    context: context,
                    message:
                        AppLocalizations.of(context)!.deleteAccConformation,
                    onTap: () async {
                      final User user = authInstance.currentUser!;
                      final uid = user.uid;
                      Navigator.pop(context);
                      try {
                        setState(() {
                          _isLoading = true;
                        });
                        final userProvider =
                            Provider.of<MemberProvider>(context, listen: false);
                        userProvider.stop();
                        final teamProvider =
                            Provider.of<TeamProvider>(context, listen: false);
                        teamProvider.stop();
                        var snapshots = await FirebaseFirestore.instance
                            .collection('teams')
                            .where('leader', isEqualTo: uid)
                            .get();
                        for (var doc in snapshots.docs) {
                          if (doc.exists) await doc.reference.delete();
                        }
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .delete();
                        Reference ref = FirebaseStorage.instance
                            .ref()
                            .child('ProfilePics/$uid.jpg');
                        try {
                          await ref.delete();
                        } on Exception {
                          await user.delete();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                          return;
                        }
                        await user.delete();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                        GlobalMethods.dialog(
                          context: context,
                          title: 'Succes!',
                          message:
                              AppLocalizations.of(context)!.deleteAccountSucces,
                        );
                      } on FirebaseException catch (error) {
                        GlobalMethods.dialogFailure(
                          context: context,
                          message: '${error.message}',
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      } catch (error) {
                        GlobalMethods.dialogFailure(
                          context: context,
                          message: '$error',
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    });
              },
              hasNavgigation: false,
            ),
          ],
        ),
      ),
    );
  }
}
