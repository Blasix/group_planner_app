import 'package:flutter/material.dart';

import '../../services/utils.dart';

class MemberWidget extends StatelessWidget {
  const MemberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      'https://firebasestorage.googleapis.com/v0/b/group-planner-d4826.appspot.com/o/Profile.jpg?alt=media&token=3dc7bc58-3bf3-4548-a2d5-09a3027190db',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: FittedBox(
                  child: Text(
                    'Name',
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
