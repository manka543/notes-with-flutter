import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/const/routes.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notes_service.dart';
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
  bool updated = true;

  @override
  void dispose(){
    final notesService = NotesService();
    notesService.disposeStreams();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Allow Notifications"),
            content: const Text('App would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Don't allow"),
              ),
              TextButton(
                  onPressed: () {
                    AwesomeNotifications()
                        .requestPermissionToSendNotifications()
                        .then(
                          (_) => Navigator.pop(context),
                        );
                  },
                  child: const Text('Allow'))
            ],
          ),
        );
      }
    });
    final notesService = NotesService();
    notesService.createNotificationListeners(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            backgroundColor: Colors.yellow,
            child: const Icon(Icons.add),
            onPressed: () async {
              final toUpdate = await Navigator.of(context).pushNamed(
                addOrEditNoteViewRoute,
              ) as bool?;
              if (toUpdate == true) {
                setState(() {
                  updated = false;
                });
              }
            },
          ),
          appBar: AppBar(
            title: const Text("Notes"),
            leading: IconButton(
              icon: const Icon(Icons.note_add),
              onPressed: () async {
                final toUpdate = await Navigator.of(context).pushNamed(
                  addOrEditNoteViewRoute,
                ) as bool?;
                if (toUpdate == true) {
                  setState(() {
                    updated = false;
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
              if (updated == false) {
                context.read<NotesBloc>().add(const GetAllNotes());
                updated = true;
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
                                  title: state.notes![index].title,
                                  text: state.notes![index].text,
                                  favourite: state.notes![index].favourite,
                                  date: state.notes![index].date,
                                  rememberdate:
                                      state.notes?[index].rememberdate,
                                  id: state.notes![index].id),
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
