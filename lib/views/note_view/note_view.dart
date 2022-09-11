import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';

class Noteview extends StatefulWidget {
  const Noteview({Key? key, required this.note}) : super(key: key);
  final DataBaseNote note;
  @override
  State<Noteview> createState() => _NoteviewState();
}

class _NoteviewState extends State<Noteview> {
  _NoteviewState();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Hero(tag: "title", child: Text(widget.note.title),)),
    );
  }
}