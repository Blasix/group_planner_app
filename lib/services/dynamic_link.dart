import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/screens/join_group.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../models/team_model.dart';
import '../providers/team_provider.dart';
import 'global_methods.dart';

//TODO the creation works i just need to figure out how to get the link to work
class DynamicLinkProvider {
  // create the link
  Future<String> createLink(String groupCode) async {
    final String url = 'https://net.blasix.group_planner_app?group=$groupCode';
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://blasix.page.link',
      link: Uri.parse(url),
      androidParameters: const AndroidParameters(
        packageName: 'net.blasix.group_planner_app',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'net.blasix.groupPlannerApp',
        minimumVersion: '0',
        // appStoreId: 'net.blasix.group_planner_app',
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'Group Planner',
        description: 'Join my group!',
      ),
    );
    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
    final refLink = await link.buildShortLink(parameters);
    return refLink.shortUrl.toString();
  }

  //init dynamic link
  Future<void> initDynamicLinks(context) async {
    //when app is open
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      //pass the group code to the join group screen
      final Uri deepLink = dynamicLink.link;
      // final User? user = authInstance.currentUser;
      try {
        final teamProvider = Provider.of<TeamProvider>(context, listen: false);
        TeamModel? team = await teamProvider
            .findGroupByID(deepLink.toString().split('?group=')[1]);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => JoinGroupScreen(
              team: team,
            ),
          ),
        );
        // if (user == null) {
        //   //not signed in
        //   GlobalMethods.dialog(
        //     context: context,
        //     title: 'Not logged in',
        //     message: 'Please log in or register, then reopen the link',
        //     contentType: ContentType.failure,
        //   );
        // } else {
        //   //signed in
        //   const JoinGroupScreen();
        //   // GlobalMethods.confirm(
        //   //   context: context,
        //   //   message:
        //   //       'Are you sure you want to join ${deepLink.queryParameters['group']}',
        //   //   onTap: () {},
        //   // );
        // }
      } catch (e) {
        print(e);
      }
    }).onError((error) {
      print(error);
    });
    //when app is closed
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      // final User? user = authInstance.currentUser;
      try {
        final teamProvider = Provider.of<TeamProvider>(context, listen: false);
        TeamModel? team = await teamProvider
            .findGroupByID(deepLink.toString().split('?group=')[1]);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => JoinGroupScreen(
              team: team,
            ),
          ),
        );
        // if (user == null) {
        //   //not signed in
        //   GlobalMethods.dialog(
        //     context: context,
        //     title: 'Not logged in',
        //     message: 'Please log in or register, then reopen the link',
        //     contentType: ContentType.failure,
        //   );
        // } else {
        //   //signed in
        //   const JoinGroupScreen();
        //   // GlobalMethods.confirm(
        //   //   context: context,
        //   //   message:
        //   //       'Are you sure you want to join ${deepLink.queryParameters['group']}',
        //   //   onTap: () {},
        //   // );
        // }
      } catch (e) {
        print(e);
      }
    }
  }
}
