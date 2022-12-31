import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/screens/join_group.dart';
import 'package:group_planner_app/services/global_methods.dart';
import 'package:provider/provider.dart';
import '../models/team_model.dart';
import '../providers/team_provider.dart';

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
      final Uri deepLink = dynamicLink.link;

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
    }).onError((error) {
      GlobalMethods.dialog(
        context: context,
        title: 'Oh snap!',
        message: error,
        contentType: ContentType.failure,
      );
    });

    //when app is closed
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
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
      } catch (e) {
        GlobalMethods.dialog(
          context: context,
          title: 'Oh snap!',
          message: e.toString(),
          contentType: ContentType.failure,
        );
      }
    }
  }
}
