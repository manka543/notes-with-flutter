import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';

class NoteListItem extends StatefulWidget {
  const NoteListItem({super.key, required this.item});
  final DataBaseNoteListItem item;
  
  @override
  State<NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).cardColor),
      child: Row(
        children: [
          IconButton(onPressed: () {
            
          }, icon: const Icon(Icons.done),),
          Expanded(child: Text(widget.item.text ?? "There is no Text")),
          IconButton(onPressed: () {
            
          }, icon: const Icon(Icons.delete))
        ],
      ),
    ),);
  }
}