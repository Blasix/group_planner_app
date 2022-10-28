// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:group_planner_app/screens/btm_bar.dart';
import 'package:provider/provider.dart';
import 'providers/member_provider.dart';
import 'providers/team_provider.dart';

class Fetch extends StatefulWidget {
  const Fetch({Key? key}) : super(key: key);

  @override
  State<Fetch> createState() => _FetchState();
}

class _FetchState extends State<Fetch> {
  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 5), () async {
      final userProvider = Provider.of<MemberProvider>(context, listen: false);
      await userProvider.fetchCurrentUser();

      final teamProvider = Provider.of<TeamProvider>(context, listen: false);
      await teamProvider.fetchTeams();
      await teamProvider.fetchSelectedTeam();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const BottomBarScreen(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitFadingFour(color: Colors.white),
      ),
    );
  }
}
