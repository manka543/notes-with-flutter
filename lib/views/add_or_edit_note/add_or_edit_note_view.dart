import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/fuctions/date_time_to_string.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_bloc.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_events.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_states.dart';

class AddOrEditNoteView extends StatefulWidget {
  const AddOrEditNoteView({Key? key}) : super(key: key);

  @override
  State<AddOrEditNoteView> createState() => _AddOrEditNoteViewState();
}

class _AddOrEditNoteViewState extends State<AddOrEditNoteView> {
  late final TextEditingController _titleController;
  late final TextEditingController _textController;
  DateTime? rememberDate;
  String? icon;
  bool rememberDateSwich = false;
  int? id;

  @override
  void initState() {
    _titleController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as int? ?? id;
    return BlocProvider(
      create: (context) => AddOrEditNoteBloc(),
      child: BlocConsumer<AddOrEditNoteBloc, AddOrEditNoteState>(
        listener: (context, state) {
          if (state is AddOrEditNoteInitialState) {
            if (id == null) {
              context
                  .read<AddOrEditNoteBloc>()
                  .add(const CreateEmptyNoteEvent());
            } else {
              context.read<AddOrEditNoteBloc>().add(GetNoteEvent(id!));
            }
          } else if (state is AddOrEditNoteStateValid) {
            setState(() {
              id = state.note!.id;
              _titleController.text = state.note!.title;
              _textController.text = state.note!.text;
              if (state.note!.rememberdate != null) {
                rememberDate = state.note!.rememberdate;
                rememberDateSwich = true;
              }
              icon = state.note!.icon;
            });
          } else if (state is DeletedState || state is UpdatedState) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          if (state is AddOrEditNoteInitialState) {
            if (id == null) {
              context
                  .read<AddOrEditNoteBloc>()
                  .add(const CreateEmptyNoteEvent());
            } else {
              context.read<AddOrEditNoteBloc>().add(GetNoteEvent(id!));
            }
          }
          return WillPopScope(
            onWillPop: (() {
              if (_titleController.text == "" && _textController.text == "") {
                context.read<AddOrEditNoteBloc>().add(DeleteNoteEvent(id));
              } else {
                final note = DataBaseNote(
                    text: _textController.text,
                    title: _titleController.text,
                    icon: "thermostat_auto",
                    date: DateTime.now(),
                    rememberdate: rememberDate,
                    id: id);
                context.read<AddOrEditNoteBloc>().add(FinalEditEvent(note));
              }
              return Future.value(false);
            }),
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Editing note"),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      context
                          .read<AddOrEditNoteBloc>()
                          .add(DeleteNoteEvent(id));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
                onPressed: () {
                  final note = DataBaseNote(
                      text: _textController.text,
                      title: _titleController.text,
                      icon: "thermostat_auto",
                      date: DateTime.now(),
                      rememberdate: rememberDate,
                      id: id);
                  context.read<AddOrEditNoteBloc>().add(EditNoteEvent(note));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Note has been saved",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.yellow,
                child: const Icon(Icons.save),
              ),
              body: ListView(
                children: [
                  const Text("Title:"),
                  TextField(
                    controller: _titleController,
                    maxLength: 60,
                    decoration: const InputDecoration(hintText: "Title"),
                  ),
                  const Text("Text:"),
                  TextField(
                    controller: _textController,
                    maxLines: null,
                    decoration: const InputDecoration(hintText: "Text of Note"),
                  ),
                  Row(
                    children: [
                      const Text("Do you want to be notify about this note?"),
                      Switch(
                        value: rememberDateSwich,
                        onChanged: (value) {
                          setState(
                            () {
                              if (value == true) {
                                rememberDate =
                                    DateTime.now().add(const Duration(days: 1));
                                rememberDateSwich = true;
                              } else {
                                rememberDate = null;
                                rememberDateSwich = false;
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Builder(
                    builder: ((context) {
                      if (!rememberDateSwich) {
                        return const Text("There won't be any notification");
                      }
                      return Column(
                        children: [
                          Text(
                              "Notification will be on: ${dateTimeToString(rememberDate!)}"),
                          const Divider(),
                          const Text(
                              "Click buttons below to pick prefered date and time"),
                          TextButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: rememberDate!,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() {
                                  rememberDate = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    rememberDate!.hour,
                                    rememberDate!.minute,
                                  );
                                });
                              }
                            },
                            child: const Text("Date Picker"),
                          ),
                          TextButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      TimeOfDay.fromDateTime(rememberDate!));
                              if (time != null) {
                                setState(() {
                                  rememberDate = rememberDate = DateTime(
                                    rememberDate!.year,
                                    rememberDate!.month,
                                    rememberDate!.day,
                                    time.hour,
                                    time.minute,
                                  );
                                });
                              }
                            },
                            child: const Text("Time Picker"),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
