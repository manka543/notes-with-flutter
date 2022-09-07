import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/fuctions/date_time_to_string.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/databasequeries.dart';
import 'package:notes/services/to_icon.dart';
import 'package:notes/views/notes/notes_event.dart';
import 'package:notes/widgets/pop_up_note_details.dart';

import '../views/notes/notes_bloc.dart';

class Note extends StatefulWidget {
  Note({Key? key, required this.databasenote}) : super(key: key);
  final DataBaseNote databasenote;
  bool selected = false;

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: (){
          setState(() {
            widget.selected = !widget.selected;
          });
        },
        child: Container(
          decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
          ),
          child: AnimatedSize(
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: Builder(
              builder: (context) {
                if (widget.selected != true){
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(icon: Hero(tag: "icon" ,child: Icon(toIcon(widget.databasenote.icon))), onPressed: () {
                        Navigator.push(context, PopUpNoteDetails(widget.databasenote));
                      },),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.databasenote.title),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.databasenote.text),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                          onPressed: () {
                            context
                            .read<NotesBloc>()
                            .add(DeleteNote(widget.databasenote.id!));
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Note has been deleted")));
                          },
                          icon: const Icon(Icons.delete_forever_outlined),
                        ),
                  ],
                );
                } else {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(toIcon(widget.databasenote.icon)),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.databasenote.title),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.databasenote.text),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Creation Date: ${dateTimeToString(widget.databasenote.date)}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Remember Date: ${dateTimeToString(widget.databasenote.rememberdate)}"),
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
                );
              }
              }
            ),
          ),
        ),
      ),
    );
  }
}
