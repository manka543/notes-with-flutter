import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/const/routes.dart';
import 'package:notes/dialogs/delete_note_alert_dialog.dart';
import 'package:notes/functions/date_time_to_string.dart';
import 'package:notes/services/to_icon.dart';
import 'package:notes/views/note_view/bloc/note_view_bloc.dart';
import 'package:notes/widgets/note_list_item.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  int? id;
  bool updated = true;
  bool noteScreenUpdated = true;
  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as int;
    return BlocProvider(
      create: (context) => NoteViewBloc(),
      child: BlocConsumer<NoteViewBloc, NoteViewState>(
        listener: (context, state) {
          if (state is NoteViewExit) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (updated == false) {
            context.read<NoteViewBloc>().add(GetNoteEvent(id!));
            updated = true;
            noteScreenUpdated = false;
          }
          if (state is NoteViewInitial) {
            context.read<NoteViewBloc>().add(GetNoteEvent(id!));
            return Scaffold(
              appBar: AppBar(title: const Text("Loading")),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is NoteViewValid) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Note Details"),
                actions: [
                  IconButton(
                    onPressed: (() {
                      if (state.note.favourite == true) {
                        context
                            .read<NoteViewBloc>()
                            .add(ChangeFavourity("false", state.note.id!));
                      } else {
                        context
                            .read<NoteViewBloc>()
                            .add(ChangeFavourity("true", state.note.id!));
                      }
                      setState(() {
                        updated = false;
                      });
                    }),
                    icon: Icon(toIcon(state.note.favourite)),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (await deleteNoteAlertDialog(context: context) !=
                            true) {
                          return;
                        }
                        context.read<NoteViewBloc>().add(DeleteNoteEvent(id!));
                      },
                      icon: const Icon(Icons.delete)),
                  // IconButton(
                  //     onPressed: () {}, icon: const Icon(Icons.more_vert)),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final toUpdate = await Navigator.of(context).pushNamed(
                    addOrEditNoteViewRoute,
                    arguments: id,
                  ) as bool?;
                  if (toUpdate == true) {
                    setState(() {
                      updated = false;
                    });
                  }
                },
                backgroundColor: Colors.yellow,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: const Icon(Icons.edit),
              ),
              body: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  Text(
                    state.note.title,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 35,
                      fontWeight: FontWeight.w300,
                      fontFamily: "ubuntu",
                    ),
                    softWrap: true,
                  ),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                  ),
                  Text(state.note.text),
                  Builder(
                    builder: (context) {
                      if (state.note.listName != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Text(
                              state.note.listName!,
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                  Builder(
                    builder: (context) {
                      if (state.note.listItems != null) {
                        var widgets = <Widget>[];
                        widgets.add(const Divider());
                        for (var noteItem in state.note.listItems!) {
                          widgets.add(NoteListItem(
                            item: noteItem,
                            changeItemProgress: (done, id) {
                              context.read<NoteViewBloc>().add(
                                  ChangeItemProgres(
                                      progress: done,
                                      id: id,
                                      note: state.note));
                            },
                            deleteItem: (id) {
                              context
                                  .read<NoteViewBloc>()
                                  .add(DeleteItem(id: id, note: state.note));
                            },
                          ));
                        }
                        return Column(
                          children: widgets,
                        );
                      }
                      return Container();
                    },
                  ),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                  ),
                  Text("Created: ${dateTimeToString(state.note.date)}"),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                  ),
                  Text(
                      "Rememberdate: ${dateTimeToString(state.note.rememberdate) ?? "no notification"}"),
                ],
              ),
            );
          } else if (state is NoteViewError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: const Center(child: Text("An error occured note loading")),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: const Center(child: Text("An error occured state loading")),
            );
          }
        },
      ),
    );
  }
}
