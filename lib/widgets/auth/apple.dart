import 'package:flutter/material.dart';
import 'package:group_planner_app/widgets/auth/other_button.dart';

class AppleButton extends StatelessWidget {
  const AppleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OtherButton(
        function: () {}, buttonImagePath: 'assets/auth/apple.png');
  }
}
