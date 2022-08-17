import 'package:flutter/material.dart';
import 'package:group_planner_app/consts/utils.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  int teamLenght = 0;
  int memberGrid = 2;

  @override
  Widget build(BuildContext context) {
    (teamLenght >= 7)
        ? setState(() {
            memberGrid = 3;
          })
        : setState(() {
            memberGrid = 2;
          });

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Row(
                // Debug buttons
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        teamLenght++;
                      });
                    },
                    child: const Text('add'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        teamLenght--;
                      });
                    },
                    child: const Text('remove'),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Theme.of(context).canvasColor,
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Text(
                        'Members',
                        style: kTitleTextStyle.copyWith(fontSize: 23),
                      ),
                    ),
                    (teamLenght == 0)
                        ? Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'There are no members in your team',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('Click to add members'))
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: memberGrid,
                                mainAxisSpacing: 32 / memberGrid,
                                crossAxisSpacing: 32 / memberGrid,
                              ),
                              itemCount: teamLenght,
                              itemBuilder: (BuildContext context, int index) {
                                return const MemberWidget();
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

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
        child: const Center(
            child: Text(
          'Member1',
          style: kTitleTextStyle,
        )),
      ),
    );
  }
}
