import 'package:flutter/material.dart';
import 'package:notes/views/add_or_edit_note_view.dart';
import 'const/routes.dart';
import 'views/notes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes:{
        addOrEditNoteViewRoute :(context) => const addOrEditNote(),
        notesRoute: (context) => const Notes(), 
      },
      home: const Notes(),
    );
  }
}
