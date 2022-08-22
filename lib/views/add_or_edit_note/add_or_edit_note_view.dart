import 'package:flutter/material.dart';

class AddOrEditNoteView extends StatefulWidget {
  const AddOrEditNoteView({Key? key}) : super(key: key);

  @override
  State<AddOrEditNoteView> createState() => _AddOrEditNoteViewState();
}

class _AddOrEditNoteViewState extends State<AddOrEditNoteView> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(appBar: AppBar(title: const Text("data"),),body: const LinearProgressIndicator(),); 
  }
}