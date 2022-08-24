import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/const/routes.dart';
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
            leading: IconButton(
              icon: const Icon(Icons.note_add),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  addOrEditNoteViewRoute,
                );
              },
            ),
          ),
          body: BlocConsumer<NotesBloc, NotesState>(
            listener: (context, state) {
              context.read<NotesBloc>().add(const GetAllNotes());
            },
            builder: (context, state) {
              if (state is NotesStateValid) {
                return DraggableScrollableSheet(initialChildSize: 1,
                minChildSize: 1,
                  builder:
                    (BuildContext context, ScrollController scrollController) {
                  return ListView.builder(
                      controller: scrollController,
                      itemCount: state.notes?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Note(
                            databasenote: DataBaseNote(
                                state.notes![index].text,
                                state.notes![index].title,
                                state.notes![index].iconData,
                                state.notes![index].date,
                                state.notes![index].rememberdate,
                                state.notes![index].id));
                      });
                });
              } else if (state is NotesStateError) {
                return const Text("An error occurred notes loading");
              } else if (state is NotesLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NotesInitState) {
                context.read<NotesBloc>().add(const GetAllNotes());
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Text("An error occurrednotes state loading");
              }
            },
          )),
    );
  }
}
