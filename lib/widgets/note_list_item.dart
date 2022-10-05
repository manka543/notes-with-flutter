import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';

class NoteListItem extends StatefulWidget {
  const NoteListItem({super.key, required this.item, required this.changeItemProgress, required this.deleteItem});
  final DataBaseNoteListItem item;
  final Function(bool done, int id) changeItemProgress;
  final Function(int id) deleteItem;

  
  @override
  State<NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), 
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: widget.item.done ? Theme.of(context).cardColor : Theme.of(context).backgroundColor),
      child: Row(
        children: [
          IconButton(onPressed: () {
            widget.changeItemProgress(!widget.item.done, widget.item.id!);
          }, icon: Icon(widget.item.done ? Icons.done : Icons.priority_high_outlined),),
          Expanded(child: AnimatedDefaultTextStyle(style: widget.item.done ? const TextStyle(decoration: TextDecoration.lineThrough): const TextStyle(), duration: const Duration(milliseconds: 500), child: Text(widget.item.text ?? "There is no text"))),
          IconButton(onPressed: () {
            widget.deleteItem(widget.item.id!);
          }, icon: const Icon(Icons.delete))
        ],
      ),
    ),);
  }
}