import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/dialogs/delete_note_alert_dialog.dart';
import 'package:notes/dialogs/exit_alert_dialog.dart';
import 'package:notes/enums/note_list_order_items.dart';
import 'package:notes/functions/date_time_to_string.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/services/to_icon.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_bloc.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_events.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_states.dart';
import 'package:notes/widgets/add_or_edit_note_list_item.dart';

class AddOrEditNoteView extends StatefulWidget {
  const AddOrEditNoteView({Key? key}) : super(key: key);

  @override
  State<AddOrEditNoteView> createState() => _AddOrEditNoteViewState();
}

class _AddOrEditNoteViewState extends State<AddOrEditNoteView> {
  late final TextEditingController _titleController;
  late final TextEditingController _textController;
  late final TextEditingController _listNameController;
  List<DataBaseNoteListItem>? itemList = [];
  DateTime? rememberDate;
  DateTime? date;
  bool rememberDateSwitch = false;
  int? noteOrder;
  int? id;
  bool archived = false;
  bool favourite = false;
  bool listSwitch = false;

  DataBaseNote get actualNote => DataBaseNote(
        id: id,
        title: _titleController.text,
        text: _textController.text,
        listName: _listNameController.text != "" ? _listNameController.text : null,
        listItems: itemList != null && itemList!.isEmpty ? null : itemList,
        rememberdate: rememberDate,
        archived: archived,
        favourite: favourite,
        date: date ?? DateTime.now(),
        order: noteOrder,
      );

  @override
  void initState() {
    _titleController = TextEditingController();
    _textController = TextEditingController();
    _listNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    _listNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    id = id ?? ModalRoute.of(context)!.settings.arguments as int?;
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
              archived = state.note!.archived;
              noteOrder = state.note!.order;
              date = state.note!.date;
              if ((state.note!.listName != null &&
                      state.note!.listName != '') ||
                  (state.note!.listItems != null &&
                      state.note!.listItems != [])) {
                listSwitch = true;
                _listNameController.text = state.note!.listName ?? "";
              } else {
                listSwitch = false;
              }
              if (state.note!.rememberdate != null) {
                rememberDate = state.note!.rememberdate;
                rememberDateSwitch = true;
              }
              //print(state.note!.listItems);
              itemList = state.note!.listItems;
              favourite = state.note!.favourite;
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
            onWillPop: (() async {
              if (_titleController.text == "" && _textController.text == "") {
                if (await showExitAlertDialog(context: context) == true) {
                  context.read<AddOrEditNoteBloc>().add(DeleteNoteEvent(id));
                  return false;
                }
              } else {
                final note = actualNote;
                context.read<AddOrEditNoteBloc>().add(FinalEditEvent(note));
              }
              return false;
            }),
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Editing note"),
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        setState(() {
                          archived = !archived;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          archived
                              ? "Note moved to archive"
                              : "Note moved out of archive",
                          style: const TextStyle(color: Colors.white),
                        )));
                      },
                      icon: Icon(
                          archived ? Icons.archive : Icons.archive_outlined)),
                  IconButton(
                    onPressed: (() {
                      if (favourite) {
                        setState(() {
                          favourite = false;
                        });
                      } else {
                        setState(() {
                          favourite = true;
                        });
                      }
                    }),
                    icon: Icon(toIcon(favourite)),
                  ),
                  IconButton(
                    onPressed: () async {
                      final option = deleteNoteAlertDialog(context: context);
                      if (await option == DeleteOptions.cancel) return;
                      if (await option == DeleteOptions.archive) {
                        archived = true;
                        context.read<AddOrEditNoteBloc>().add(FinalEditEvent(actualNote));
                        return;
                      }
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
                  final note = actualNote;
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
              body: ListView(padding: const EdgeInsets.all(15), children: [
                const Text(
                  "Title:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                ),
                TextField(
                  controller: _titleController,
                  maxLength: 60,
                  decoration: const InputDecoration(hintText: "Title"),
                ),
                const Text(
                  "Text:",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                ),
                TextField(
                  controller: _textController,
                  maxLines: null,
                  decoration: const InputDecoration(hintText: "Text of Note"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Do you want to have list in your note"),
                    Switch(
                      activeColor: Colors.yellow,
                      value: listSwitch,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _listNameController.text =
                                state.note!.listName ?? "";
                            itemList = [];
                          } else {
                            _listNameController.text = "";
                            itemList = null;
                          }
                          listSwitch = value;
                        });
                      },
                    ),
                  ],
                ),
                Builder(
                  builder: (context) {
                    if (listSwitch == true) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Title of list:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                          TextField(
                            controller: _listNameController,
                            maxLength: 60,
                            decoration: const InputDecoration(
                                hintText: "Name of your note's list"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    itemList ??= [];
                                    setState(() {
                                      itemList!.add(const DataBaseNoteListItem(
                                        text: "",
                                        done: false,
                                        id: null,
                                      ));
                                    });
                                  },
                                  child: const Text("Add new item")),
                              PopupMenuButton(
                                itemBuilder: (context) {
                                  return <PopupMenuEntry<NoteListOrderItems>>[
                                    PopupMenuItem<NoteListOrderItems>(
                                      value:
                                          NoteListOrderItems.alphabeticallyDown,
                                      child: Row(
                                        children: const [
                                          Text("Alphabetically"),
                                          Icon(Icons.arrow_downward),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<NoteListOrderItems>(
                                      value:
                                          NoteListOrderItems.alphabeticallyUp,
                                      child: Row(
                                        children: const [
                                          Text("Alphabetically"),
                                          Icon(Icons.arrow_upward),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                child: const Icon(Icons.sort),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),

                Builder(
                  builder: (context) {
                    var widgets = <Widget>[const Divider()];
                    if (itemList?.isNotEmpty ?? false) {
                      for (var i = 0; i < itemList!.length; i++) {
                        widgets.add(AddOrEditNoteListItem(
                            key: UniqueKey(),
                            item: itemList![i],
                            getItem: (DataBaseNoteListItem itemA) {
                              itemList![i] = itemA;
                            },
                            deleteItem: () {
                              setState(() {
                                itemList!.removeAt(i);
                              });
                            }));
                      }
                    }
                    return Column(
                      children: widgets,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Do you want to be notify about this note?"),
                    Switch(
                      activeColor: Colors.yellow,
                      value: rememberDateSwitch,
                      onChanged: (value) {
                        setState(
                          () {
                            if (value == true) {
                              rememberDate =
                                  DateTime.now().add(const Duration(days: 1));
                              rememberDateSwitch = true;
                            } else {
                              rememberDate = null;
                              rememberDateSwitch = false;
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
                Builder(
                  builder: ((context) {
                    if (!rememberDateSwitch) {
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
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
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
              ]),
            ),
          );
        },
      ),
    );
  }
}
