import 'package:flutter/material.dart';

class OtherButton extends StatelessWidget {
  const OtherButton(
      {Key? key, required this.function, required this.buttonImagePath})
      : super(key: key);
  final Function function;
  final String buttonImagePath;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).bottomAppBarColor,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () {
            function();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Image.asset(
              buttonImagePath,
              height: 40,
              width: 40,
            ),
          ),
        ));
  }
}
