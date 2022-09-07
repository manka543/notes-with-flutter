import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/const/routes.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/views/notes/notes_bloc.dart';
import 'package:notes/views/notes/notes_event.dart';
import 'package:notes/widgets/best_note.dart';

import 'notes_state.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  DataBaseNote? noteToCreate;
  DataBaseNote? noteToUpdate;
  DataBaseNote? noteToDelete;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            backgroundColor: Colors.yellow,
            child: const Icon(Icons.add),
            onPressed: () async {
                final note = await Navigator.of(context).pushNamed(
                  addOrEditNoteViewRoute,
                ) as DataBaseNote?;
                if (note != null) {
                  setState(() {
                    noteToCreate = note;
                    //ScaffoldMessenger.of(context).showSnackBar(
                    //const SnackBar(content: Text("Note has been created")));
                  });
                }
              },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.abc), label: "sie"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.audio_file), label: "sie"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome), label: "nic"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.motion_photos_auto_rounded), label: "nie"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.theater_comedy), label: "dzieje"),
            ],
          ),
          appBar: AppBar(
            title: const Text("notes"),
            leading: IconButton(
              icon: const Icon(Icons.note_add),
              onPressed: () async {
                final note = await Navigator.of(context).pushNamed(
                  addOrEditNoteViewRoute,
                ) as DataBaseNote?;
                if (note != null) {
                  setState(() {
                    noteToCreate = note;
                    //ScaffoldMessenger.of(context).showSnackBar(
                    //const SnackBar(content: Text("Note has been created")));
                  });
                }
              },
            ),
          ),
          body: BlocConsumer<NotesBloc, NotesState>(
            listener: (context, state) {
              //do nothing
            },
            builder: (context, state) {
              if (noteToCreate != null) {
                context.read<NotesBloc>().add(AddNote(noteToCreate!));
                noteToCreate = null;
                
              }
              if (noteToUpdate != null) {
                context.read<NotesBloc>().add(UpdateNote(noteToUpdate!));
                noteToUpdate = null;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Note has been updated")));
              }
              if (noteToDelete != null) {
                context.read<NotesBloc>().add(DeleteNote(noteToDelete!.id!));
                noteToDelete = null;
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Note has been deleted")));
              }
              if (state is NotesStateValid) {
                return DraggableScrollableSheet(
                    initialChildSize: 1,
                    minChildSize: 1,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return ListView.builder(
                          controller: scrollController,
                          itemCount: state.notes?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Note(
                              note: DataBaseNote(
                                  state.notes![index].title,
                                  state.notes![index].text,
                                  state.notes![index].icon,
                                  state.notes![index].date,
                                  state.notes?[index].rememberdate,
                                  state.notes![index].id),
                            );
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
