import 'package:flutter/material.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_view.dart';
import 'const/routes.dart';
import 'views/notes/notes.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.yellow.shade700,
        onPrimary: Colors.black,
        secondary: Colors.grey,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.black,
        background: Colors.black26,
        onBackground: Colors.white,
        surface: Colors.yellow.shade700,
        onSurface: Colors.black,
      )),
      routes: {
        addOrEditNoteViewRoute: (context) => const AddOrEditNoteView(),
        notesRoute: (context) => const Notes(),
      },
      home: const Notes(),
    );
  }
}
