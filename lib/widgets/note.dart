import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';

class Note extends StatelessWidget {
  final DataBaseNote databasenote;

  const Note({Key? key, required this.databasenote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
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
=======
    return Placeholder(color: Colors.red,strokeWidth: 45,child: IconButton(onPressed: (){},icon:const Icon(Icons.error),));
>>>>>>> 072db34 (notes service)
  }
}
