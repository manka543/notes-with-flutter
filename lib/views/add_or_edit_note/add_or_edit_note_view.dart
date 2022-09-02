import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';
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
  bool rememberDateSwich = false;

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

  String dateTimeToString(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ((){
        Navigator.pop(
      context, DataBaseNote(_textController.text, _titleController.text, "thermostat_auto", DateTime.now(), rememberDate, null)
      );
      return Future.value(false);
      }),
      child: Scaffold(
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
                          lastDate: DateTime.now().add(const Duration(days: 365)),
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
                            initialTime: TimeOfDay.fromDateTime(rememberDate!));
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
  }
}
