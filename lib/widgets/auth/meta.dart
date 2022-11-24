import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:group_planner_app/widgets/auth/other_button.dart';

import '../../consts/firebase_consts.dart';
import '../../fetch.dart';

class MetaButton extends StatelessWidget {
  const MetaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OtherButton(
        function: () async {
          // Trigger the sign-in flow
          final LoginResult loginResult = await FacebookAuth.instance.login();

          // Create a credential from the access token
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(loginResult.accessToken!.token);

          // Once signed in, return the UserCredential
          await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);

          final userData = await FacebookAuth.instance.getUserData();
          final uid = authInstance.currentUser!.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'id': uid,
            'username': userData['name'],
            'email': userData['email'],
            'profilePictureUrl': userData['picture']['data']['url'],
            'createdAt': Timestamp.now(),
            'selectedTeam': '',
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Fetch(),
            ),
          );
        },
        buttonImagePath: 'assets/images/auth/meta.png');
  }
}
