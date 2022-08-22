import 'package:flutter/material.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_view.dart';
import 'const/routes.dart';
import 'views/notes/notes.dart';

void main() async {
  runApp(const MyApp());
  print(DateTime.now());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      routes: {
        addOrEditNoteViewRoute: (context) => const AddOrEditNoteView(),
        notesRoute: (context) => const Notes(),
      },
      home: const Notes(),
    );
  }
}
