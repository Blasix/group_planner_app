import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/member_model.dart';

class VotedMembers extends StatelessWidget {
  const VotedMembers({super.key});

  @override
  Widget build(BuildContext context) {
    final memberModel = Provider.of<TeamMemberModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Text(memberModel.name,
                  style: Theme.of(context).textTheme.headline6),
              const Spacer(),
              memberModel.pictureURL != ''
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(memberModel.pictureURL),
                    )
                  : const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/group-planner-d4826.appspot.com/o/Profile.jpg?alt=media&token=3dc7bc58-3bf3-4548-a2d5-09a3027190db'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
