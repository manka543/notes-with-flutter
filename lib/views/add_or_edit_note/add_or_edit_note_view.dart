import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/services/database_note.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_bloc.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_events.dart';
import 'package:notes/views/add_or_edit_note/add_or_edit_note_states.dart';

import '../../const/routes.dart';

class AddOrEditNoteView extends StatefulWidget {
  const AddOrEditNoteView({Key? key}) : super(key: key);

  @override
  State<AddOrEditNoteView> createState() => _AddOrEditNoteViewState();
}

class _AddOrEditNoteViewState extends State<AddOrEditNoteView> {
  late final TextEditingController _titleController;
  late final TextEditingController _textController;
  DateTime? rememberDate;
  IconData? icon;
  bool rememberDateSwich = true;

  @override
  void initState() {
    _titleController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() async {
    Navigator.pop(
      context,
    );
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  String dateTimeToString(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay timePickerInitialTime = TimeOfDay.now();
    DateTime datePickerInitialDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
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
                  setState(() {if (value == true) {
                    rememberDate = DateTime.now().add(const Duration(days: 1));
                    rememberDateSwich = true;
                  } else {
                    rememberDate = null;
                    rememberDateSwich = false;
                  }
                },);}
              ),
            ],
          ),
          Builder(builder:((context) {
            if(!rememberDateSwich) return const Text("There won't be any notification");
            return Column(
              children: [
                const Text("nic"),
                const Text("nic ale drugi raz"),
                Text(rememberDate.toString()),
              ],
            );
          }),),
        ],
      ),
    );
  }
}
