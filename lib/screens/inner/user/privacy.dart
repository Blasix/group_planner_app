import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/consts/loading_manager.dart';

import '../../../consts/firebase_consts.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: TextButton(
            onPressed: () {
              GlobalMethods.confirm(
                  context: context,
                  message: 'Are you sure you want to delete your account',
                  onTap: () async {
                    final User user = authInstance.currentUser!;
                    final uid = user.uid;
                    Navigator.pop(context);
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      var snapshots = await FirebaseFirestore.instance
                          .collection('teams')
                          .where('leader', isEqualTo: uid)
                          .get();
                      for (var doc in snapshots.docs) {
                        await doc.reference.delete();
                      }
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .delete();
                      await user.delete();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      GlobalMethods.dialog(
                        context: context,
                        title: 'Succes!',
                        message: 'Your account has been deleted',
                        contentType: ContentType.success,
                      );
                    } on FirebaseException catch (error) {
                      GlobalMethods.dialog(
                        context: context,
                        title: 'On snap!',
                        message: '${error.message}',
                        contentType: ContentType.failure,
                      );
                      setState(() {
                        _isLoading = false;
                      });
                      return;
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
                      return;
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  });
            },
            child: const Text('Delete account')),
      ),
    );
  }
}
