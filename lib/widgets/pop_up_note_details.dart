import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/fuctions/date_time_to_string.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/to_icon.dart';

class PopUpNoteDetails extends PopupRoute<void> {
  final DataBaseNote databasenote;

  PopUpNoteDetails(this.databasenote);
  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Colors.transparent;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => databasenote.title;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 400,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Hero(tag: "Icon", child: Icon(toIcon(databasenote.icon))),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(databasenote.title),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(databasenote.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Creation Date: ${dateTimeToString(databasenote.date)}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Remember Date: ${dateTimeToString(databasenote.rememberdate)}"),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_forever_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_forever_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete_forever_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 10);
}
