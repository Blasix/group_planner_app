import 'package:flutter/material.dart';
import 'package:group_planner_app/models/team_model.dart';
import 'package:provider/provider.dart';

import '../../services/utils.dart';

class SelectTeamWidget extends StatelessWidget {
  const SelectTeamWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teamModel = Provider.of<TeamModel>(context);
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
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
                children: [
                  Text(
                    teamModel.name,
                    style: kTitleTextStyle,
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
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
      ),
    );
  }
}
