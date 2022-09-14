import 'package:flutter/material.dart';
import 'package:notes/services/awesome_notifications_service.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_view.dart';
import 'package:notes/views/note_view/bloc/note_view.dart';
import 'const/routes.dart';
import 'views/notes/notes.dart';

void main() async {
  final service = AwesomeNotificationService();
  service.ensureInitializaed();
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
        primary: Colors.white,
        onPrimary: Colors.black12,
        secondary: Colors.grey,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.red.shade300,
        background: Colors.white,
        onBackground: Colors.black26,
        surface: Colors.yellow,
        onSurface: Colors.black,
      )),
      routes: {
        addOrEditNoteViewRoute: (context) => const AddOrEditNoteView(),
        notesRoute: (context) => const Notes(),
        //popUpNoteDetailsRoute: (context, DataBaseNote note) => PopUpNoteDetails(),
        //notesViewRoute :(context, note) => NoteView(note: note,),
        noteViewRoute: (context) => const NoteView(),
      },
      home: const Notes(),
    );
  }
}
