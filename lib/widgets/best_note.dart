import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/fuctions/date_time_to_string.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/to_icon.dart';
import 'package:notes/views/notes/notes_bloc.dart';
import 'package:notes/views/notes/notes_event.dart';

class Note extends StatefulWidget {
  const Note({Key? key, required this.note}) : super(key: key);
  final DataBaseNote note;

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              decoration: selected
                  ? BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)))
                  : BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
              child: selected
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(toIcon(widget.note.icon)),
                        ),
                        Expanded(child: Hero(tag: "title",child: Text(widget.note.text))),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          onPressed: () {
                            setState(() {
                              selected = !selected;
                            });
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(toIcon(widget.note.icon)),
                        ),
                        Expanded(child: Text(widget.note.text)),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_left),
                          onPressed: () {
                            setState(() {
                              selected = !selected;
                            });
                          },
                        ),
                      ],
                    ),
            ),
            AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(seconds: 1),
              height: selected ? 150 : 0,
              child: Container(
                decoration: selected
                    ? BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(15)))
                    : BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.note.title,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      ClipRect(
                        child: Column(
                          children: [
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    selected = false;
                                    context
                                        .read<NotesBloc>()
                                        .add(DeleteNote(widget.note.id!));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text(
                                      "Note has been deleted",
                                      style: TextStyle(color: Colors.white),
                                    )));
                                  },
                                  icon: const Icon(Icons.delete)),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, );
                                  },
                                  icon: const Icon(Icons.zoom_in)),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
