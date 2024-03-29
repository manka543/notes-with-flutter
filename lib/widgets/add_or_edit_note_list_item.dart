import 'package:flutter/material.dart';
import 'package:notes/services/database_note.dart';

class AddOrEditNoteListItem extends StatefulWidget {
  const AddOrEditNoteListItem(
      {super.key,
      required this.item,
      required this.getItem,
      required this.deleteItem});
  final Function(DataBaseNoteListItem) getItem;
  final Function() deleteItem;
  final DataBaseNoteListItem item;
  @override
  State<AddOrEditNoteListItem> createState() => _AddOrEditNoteListItemState();
}

class _AddOrEditNoteListItemState extends State<AddOrEditNoteListItem> {
  late final TextEditingController _controller;
  bool? done;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    done ??= widget.item.done;
    _controller.text = widget.item.text!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.item.done
              ? Theme.of(context).disabledColor
              : Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    done = !done!;
                  });
                  widget.getItem(DataBaseNoteListItem(
                    text: _controller.text,
                    done: done!,
                    id: widget.item.id,
                  ));
                },
                icon: Icon(done! ? Icons.done : Icons.priority_high_outlined)),
            Expanded(
                child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Text of item"),
              onChanged: (value) {
                widget.getItem(DataBaseNoteListItem(
                  text: _controller.text,
                  done: done!,
                  id: widget.item.id,
                ));
              },
            )),
            IconButton(
                onPressed: () {
                  widget.deleteItem();
                },
                icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
