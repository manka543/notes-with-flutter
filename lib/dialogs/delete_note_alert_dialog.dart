import 'package:flutter/material.dart';
import 'package:notes/dialogs/generic_dialog.dart';

Future<bool?> deleteNoteAlertDialog({
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
      context: context,
      title: "Are you sure you want to delete this note?",
      actions: {"OK": true, "Cancel": false}).then(
    (value) {
      return value ?? false;
    },
  );
}