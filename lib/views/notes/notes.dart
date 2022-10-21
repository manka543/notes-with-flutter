import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/const/routes.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/notes_service.dart';
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
  DataBaseNote? noteToCreate;
  DataBaseNote? noteToUpdate;
  DataBaseNote? noteToDelete;
  bool updated = true;

  @override
  void dispose() {
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
    List<DataBaseNote>? noteslist;
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
              if(state is NotesStateValid){
                noteslist = state.notes;
                print(noteslist);
              }
            },
            builder: (context, state) {
              if (updated == false) {
                context.read<NotesBloc>().add(const GetAllNotes());
                updated = true;
              }
              if (state is NotesStateValid) {
                var widgets = <Widget>[];
                for (var note in noteslist ?? state.notes!) {
                  widgets.add(Note(
                    note: note,
                    key: UniqueKey(),
                  ));
                }
                return ReorderableListView.builder(
                  itemBuilder: (context, index) {
                    return widgets[index];
                  },
                  itemCount: state.notes!.length,
                  physics: const BouncingScrollPhysics(),
                  onReorder: (oldIndex, newIndex) {
                    print("i am reordering: $oldIndex, $newIndex");
                    int? displacement;
                    if(oldIndex > newIndex) {
                    displacement = 1;
                    } else {
                      displacement = 0;
                    }
                    setState(() {
                    noteslist ??= state.notes;
                    noteslist!.insert(newIndex, state.notes![oldIndex]);
                    noteslist!.removeAt(oldIndex + displacement!);
                    });

                    // setState(() {
                    // state.notes!.insert(newIndex, state.notes![oldIndex]);
                    // state.notes!.remove(state.notes![oldIndex]);
                    // });
                    context.read<NotesBloc>().add(ChangeItemOrder(noteslist!));
                  },
                );
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
