import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class addOrEditNote extends StatefulWidget {
  const addOrEditNote({Key? key}) : super(key: key);

  @override
  State<addOrEditNote> createState() => _addOrEditNoteState();
}

class _addOrEditNoteState extends State<addOrEditNote> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text("abc"),);
  }
}