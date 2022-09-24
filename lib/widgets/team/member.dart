import 'package:flutter/material.dart';
import 'package:group_planner_app/models/member_model.dart';
import 'package:provider/provider.dart';

import '../../services/utils.dart';

class MemberWidget extends StatelessWidget {
  const MemberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final memberModel = Provider.of<MemberModel>(context);
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).cardColor.withOpacity(0.9),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      (memberModel.pictureURL == '')
                          ? 'https://firebasestorage.googleapis.com/v0/b/group-planner-d4826.appspot.com/o/Profile.jpg?alt=media&token=3dc7bc58-3bf3-4548-a2d5-09a3027190db'
                          : memberModel.pictureURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FittedBox(
                  child: Text(
                    memberModel.name,
                    style: kTitleTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
