import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/const/routes.dart';
import 'package:notes/dialogs/delete_note_alert_dialog.dart';
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
  bool? toUpdate;
  @override
  Widget build(BuildContext context) {
    if (toUpdate == true) {
      context.read<NotesBloc>().add(GetAllNotes(widget.note.archived));
      setState(() => toUpdate = false);
    }
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
                : widget.note.favourite
                    ? BoxDecoration(
                        color: Theme.of(context).hintColor,
                        borderRadius: BorderRadius.circular(15))
                    : BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(15)),
            child: selected
                ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            if (widget.note.favourite) {
                              context.read<NotesBloc>().add(ChangeFavourity(
                                  "false",
                                  widget.note.id!,
                                  widget.note.archived));
                            } else {
                              context.read<NotesBloc>().add(ChangeFavourity(
                                  "true",
                                  widget.note.id!,
                                  widget.note.archived));
                            }
                          },
                          icon: Icon(
                            toIcon(widget.note.favourite),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(widget.note.title),
                      )),
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
                        child: IconButton(
                          onPressed: () {
                            if (widget.note.favourite) {
                              context.read<NotesBloc>().add(ChangeFavourity(
                                  "false",
                                  widget.note.id!,
                                  widget.note.archived));
                            } else {
                              context.read<NotesBloc>().add(ChangeFavourity(
                                  "true",
                                  widget.note.id!,
                                  widget.note.archived));
                            }
                          },
                          icon: Icon(toIcon(widget.note.favourite)),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(widget.note.title),
                      )),
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
                        widget.note.text,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    ClipRect(
                      child: Column(
                        children: [
                          Expanded(
                            child: IconButton(
                                onPressed: () async {
                                  final option = widget.note.archived == false
                                      ? deleteNoteAlertDialog(context: context)
                                      : deleteArchivedNoteAlertDialog(
                                          context: context);
                                  if (await option == DeleteOptions.cancel) {
                                    return;
                                  }
                                  if (await option == DeleteOptions.archive) {
                                    context.read<NotesBloc>().add(
                                        ChangeArchived(
                                            true, widget.note.id!, false));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                            content: Text(
                                      "Note ",
                                      style: TextStyle(color: Colors.white),
                                    )));
                                    return;
                                  }
                                  selected = false;
                                  context.read<NotesBloc>().add(DeleteNote(
                                      widget.note.id!, widget.note.archived));
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
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                      context, noteViewRoute,
                                      arguments: widget.note.id);
                                  setState(() {
                                    toUpdate = true;
                                  });
                                },
                                icon: const Icon(Icons.zoom_in)),
                          ),
                          Expanded(
                            child: IconButton(
                                onPressed: () async {
                                  final updated = await Navigator.pushNamed(
                                      context, addOrEditNoteViewRoute,
                                      arguments: widget.note.id) as bool?;
                                  if (updated != null) {
                                    setState(() {
                                      toUpdate = updated;
                                    });
                                  }
                                },
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
      ),
    );
  }
}
