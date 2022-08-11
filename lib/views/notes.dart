import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/widgets/note.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(title: const Text("notes"),),
      body: DraggableScrollableSheet(
        builder:(BuildContext context, ScrollController scrollController){
          return Container(
            child: ListView.builder(
              controller: scrollController,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index){
                return Note(databasenote: DataBaseNote("nothing special is in me", "nth special", const Icon(Icons.abc, size: 40,), DateTime.now(), DateTime.now()));
        }), 
        );
  }));
  }
}
