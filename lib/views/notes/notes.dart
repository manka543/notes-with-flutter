import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/views/notes/notes_bloc.dart';
import 'package:notes/views/notes/notes_event.dart';
import 'package:notes/widgets/note.dart';

import 'notes_state.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("notes"),
            leading: const Text("there is nothing"),
          ),
          body: BlocConsumer<NotesBloc, NotesState>(
            listener: (context, state) {
              context.read<NotesBloc>().add(const GetAllNotes());
            },
            builder: (context, state) {
              return DraggableScrollableSheet(builder:
                  (BuildContext context, ScrollController scrollController) {
                return ListView.builder(
                    controller: scrollController,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Note(
                          databasenote: DataBaseNote(
                              "nothing special is in me",
                              "nth special",
                              Icons.abc,
                              DateTime.now(),
                              DateTime.now(),
                              null));
                    });
              });
            },
          )),
    );
  }
}
