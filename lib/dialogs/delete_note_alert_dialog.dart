import 'package:flutter/material.dart';
import 'package:notes/dialogs/generic_dialog.dart';

enum DeleteOptions { archive, delete, cancel }

Future<DeleteOptions> deleteNoteAlertDialog({
  required BuildContext context,
}) {
  return showGenericDialog<DeleteOptions>(
      context: context,
      title: "Are you sure you want to delete this note?",
      content:
          "You can also move this note to archive by pressing button below",
      actions: {
        "Move to archive": DeleteOptions.archive,
        "Delete": DeleteOptions.delete,
        "Cancel": DeleteOptions.cancel
      }).then(
    (value) {
      return value ?? DeleteOptions.cancel;
    },
  );
}

Future<DeleteOptions> deleteArchivedNoteAlertDialog({
  required BuildContext context,
}) {
  return showGenericDialog<DeleteOptions>(
      context: context,
      title: "Are you sure you want to delete this note?",
      actions: {
        "Delete": DeleteOptions.delete,
        "Cancel": DeleteOptions.cancel
      }).then(
    (value) {
      return value ?? DeleteOptions.cancel;
    },
  );
}
