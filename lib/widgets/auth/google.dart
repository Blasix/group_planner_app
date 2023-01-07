import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_planner_app/widgets/auth/other_button.dart';

import '../../consts/firebase_consts.dart';
import '../../fetch.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OtherButton(
        function: () async {
          // Trigger the authentication flow
          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

          // Obtain the auth details from the request
          final GoogleSignInAuthentication? googleAuth =
              await googleUser?.authentication;

          if (googleAuth == null) return;

          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          // Once signed in, return the UserCredential
          await FirebaseAuth.instance.signInWithCredential(credential);

          final uid = authInstance.currentUser!.uid;
          // only add user to database if it doesn't exist
          if (await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get()
              .then((value) => !value.exists)) {
            await FirebaseFirestore.instance.collection('users').doc(uid).set({
              'id': uid,
              'username': googleUser?.displayName,
              'email': googleUser?.email,
              'profilePictureUrl': googleUser?.photoUrl,
              'createdAt': Timestamp.now(),
              'selectedTeam': '',
            });
          }
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Fetch(),
            ),
          );
        },
        buttonImagePath: 'assets/images/auth/google.png');
  }
}
