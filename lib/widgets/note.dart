import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';

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
        leading: databasenote.icon,
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
