import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/fuctions/date_time_to_string.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notification_service.dart';
import 'package:notes/services/to_icon.dart';

import '../views/notes/notes_bloc.dart';
import '../views/notes/notes_event.dart';

class Note extends StatefulWidget {
  final DataBaseNote databasenote;

  const Note({Key? key, required this.databasenote}) : super(key: key);

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Builder(builder: (context) {
        if (selected == false) {
          return ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tileColor: Colors.grey,
            title: Text(widget.databasenote.title),
            subtitle: Builder(builder: (context) {
              if (selected == false) {
                return Text(widget.databasenote.text +
                    widget.databasenote.id.toString());
              } else {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        widget.databasenote.text +
                            widget.databasenote.id.toString(),
                      ),
                    ),
                    Text(
                        "Notification date: ${dateTimeToString(widget.databasenote.rememberdate)}\nNote created: ${dateTimeToString(widget.databasenote.date)}")
                  ],
                );
              }
            }),
            leading: IconButton(
              icon: Icon(
                toIcon(widget.databasenote.icon),
                size: 42,
              ),
              onPressed: () {
                final notificationService = NotificationService();
                //notificationService.ensureInitializaed();
                notificationService.showNotification(
                    id: widget.databasenote.id!,
                    title: widget.databasenote.title,
                    text: widget.databasenote.text);
              },
            ),
            trailing: Builder(builder: (context) {
              if (!selected) {
                return IconButton(
                  onPressed: () {
                    context
                        .read<NotesBloc>()
                        .add(DeleteNote(widget.databasenote.id!));
                  },
                  icon: const Icon(Icons.delete),
                );
              } else {
                return FittedBox(
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          context
                              .read<NotesBloc>()
                              .add(DeleteNote(widget.databasenote.id!));
                          selected = false;
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_calendar),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                );
              }
            }),
            selectedTileColor: Colors.blueGrey,
            selected: selected,
            onTap: () => setState(() {
              selected = !selected;
            }),
            isThreeLine: false,
            contentPadding: const EdgeInsets.all(5),
          );
        } else {
          return GestureDetector(
            onTap: (() {
              setState(() {
              selected = !selected;
            });
            }),
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                color: Theme.of(context).cardColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13),
                    child: Icon(toIcon(widget.databasenote.icon),size: 42,),
                  ),
                  SizedBox(
                    width: 252,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(widget.databasenote.title, style: Theme.of(context).textTheme.subtitle1,),
                      const Divider(height: 5,),
                      Text(widget.databasenote.text, style: Theme.of(context).textTheme.bodyText2,),
                      const Divider(height: 5,),
                      Text("Created: ${dateTimeToString(widget.databasenote.date)}", style: Theme.of(context).textTheme.bodyText2,),
                      Text("Notification: ${dateTimeToString(widget.databasenote.rememberdate)}", style: Theme.of(context).textTheme.bodyText2,),
                    ],),
                  ),
                  Column(children: [
                    IconButton(onPressed: () {
                      print("delete");
                    }, icon: const Icon(Icons.delete)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                  ],),
                ],
              )),
          );
        }
      },),
    );
  }
}
