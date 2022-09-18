import 'package:flutter/material.dart';

import '../../screens/inner/team/select_team.dart';
import '../../services/utils.dart';

class TeamWidget extends StatelessWidget {
  const TeamWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).canvasColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
              ),
              height: 60,
              width: 60,
              child: const Center(child: Text("icon")),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: const [
                Text(
                  'Team name',
                  style: kTitleTextStyle,
                ),
                Text('edit')
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectTeamScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.menu_rounded,
                  size: 40,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
