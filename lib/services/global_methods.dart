import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/services/utils.dart';
import 'package:iconly/iconly.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlobalMethods {
  static confirm({
    required BuildContext context,
    required String message,
    required Function onTap,
  }) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: message,
        title: AppLocalizations.of(context)!.sure,
        confirmBtnText: AppLocalizations.of(context)!.yes,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        titleColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.primary,
        cancelBtnText: AppLocalizations.of(context)!.no,
        confirmBtnColor: Colors.red,
        onConfirmBtnTap: () {
          onTap();
        });
  }

  static dialogFailure(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: "Oh snap!",
          message: message,
          contentType: ContentType.failure,
        ),
      ),
    );
  }

  static dialog(
      {required BuildContext context,
      required String title,
      required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: ContentType.success,
        ),
      ),
    );
  }

  static profileListItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Function onPressed,
    bool hasNavgigation = true,
  }) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).cardColor),
      child: InkWell(
        onTap: () {
          onPressed(context);
        },
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(text,
                  style: kTitleTextStyle.copyWith(fontWeight: FontWeight.w500)),
              const Spacer(),
              Visibility(
                visible: hasNavgigation,
                child: const Icon(
                  IconlyLight.arrow_right_2,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
