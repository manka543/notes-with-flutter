import 'package:flutter/material.dart';
import 'package:notes/dialogs/generic_dialog.dart';

Future<bool?> showExitAlertDialog({
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
      context: context,
      title: "Note might not be saved",
      content:
          "If you don't write anything in title or text box, note will not be saved",
      actions: {"OK": true, "Cancel": false}).then(
    (value) {
      return value ?? false;
    },
  );
}
