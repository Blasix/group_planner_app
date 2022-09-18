import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
        confirmBtnText: 'Yes',
        backgroundColor: Theme.of(context).bottomAppBarColor,
        titleColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.primary,
        cancelBtnText: 'No',
        confirmBtnColor: Colors.red,
        onConfirmBtnTap: () {
          onTap();
        });
  }

  static dialog(
      {required BuildContext context,
      required String title,
      required String message,
      required ContentType contentType}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      ),
    );
  }
}
