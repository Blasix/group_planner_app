import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/team_model.dart';
import '../consts/firebase_consts.dart';
import 'btm_bar.dart';

class JoinGroupScreen extends StatefulWidget {
  final TeamModel? team;

  const JoinGroupScreen({Key? key, required this.team}) : super(key: key);

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  @override
  Widget build(BuildContext context) {
    void joinGroup() {
      widget.team!.uuid;
      FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.team!.uuid)
          .update({
        'members': FieldValue.arrayUnion([authInstance.currentUser!.uid])
      });
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('join group'),
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) => const BottomBarScreen(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Theme.of(context).cardColor,
          ),
          child: !widget.team!.members.contains(authInstance.currentUser!.uid)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.team!.name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () {
                            joinGroup();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const BottomBarScreen(),
                              ),
                            );
                          },
                          child: const Text('join group'),
                        ),
                      ],
                    )
                  ],
                )
              : const Center(child: Text('Your already in this group')),
        ),
      ),
    );
  }
}

// https://blasix.page.link/fnb2