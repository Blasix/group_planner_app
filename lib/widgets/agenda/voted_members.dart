import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/member_model.dart';

class VotedMembers extends StatelessWidget {
  const VotedMembers({super.key});

  @override
  Widget build(BuildContext context) {
    final memberModel = Provider.of<TeamMemberModel>(context);
    return Row(
      children: [
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
        const SizedBox(width: 8),
        SizedBox(
          width: 280,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(memberModel.name,
                style: Theme.of(context).textTheme.headline5),
          ),
        ),
      ],
    );
  }
}
