import 'package:flutter/material.dart';

/// 跳出提示訊息
///
/// @Parameter(<BuildContext>['context', 'BuildContext context'])
///
/// @Parameter(<String>['title', 'AlertDialog title'])
///
/// @Parameter(<String>['text', 'AlertDialog content'])
showAlertDialog(BuildContext context, String title, String text) {
  // set up the button

  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
