import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/to_icon.dart';

import '../views/notes/notes_bloc.dart';
import '../views/notes/notes_event.dart';
class Note extends StatelessWidget {
  final DataBaseNote databasenote;

  const Note({Key? key, required this.databasenote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.grey,
        title: Text(databasenote.title),
        subtitle: Text(databasenote.text),
        leading: Icon(toIcon(databasenote.icon), size: 42,),
        trailing: IconButton(
          onPressed: () {
            context.read<NotesBloc>().add(DeleteNote(databasenote.id!));
          },
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
