import 'package:flutter/material.dart';

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required Map<String, dynamic> actions,
  String? content,
}) {
  return showDialog(
      context: context,
      builder: ((context) {
        List<Widget> widgets = [];
        for (var action in actions.keys) {
          widgets.add(TextButton(onPressed: () {
            Navigator.of(context).pop(actions[action]);
          }, child: Text(action)));
        }
        return AlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          actions: widgets);
      }));
}
