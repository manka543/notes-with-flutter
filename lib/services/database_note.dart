class DataBaseNote {
  final int? id;
  final String text;
  final String title;
  final int? order;
  final bool favourite;
  final bool archived;
  final DateTime date;
  late final DateTime? rememberdate;
  final String? listName;
  final List<DataBaseNoteListItem>? listItems;

  DataBaseNote({
    required this.title,
    required this.text,
    required this.favourite,
    required this.date,
    this.order,
    this.rememberdate,
    this.id,
    this.listName,
    this.listItems,
    this.archived = false,
  });

  @override
  String toString() {
    return ("Instance of DataBaseNote; ID: $id, TITLE: $title, TEXT: $text, FAVOURITE: $favourite, DATE: $date, REMEMBERDATE: $rememberdate, LISTNAME: $listName, LISTITEMS: $listItems, ORDER: $order");
  }
}

class DataBaseNoteListItem {
  const DataBaseNoteListItem({this.text, required this.done, this.id});
  final String? text;
  final bool done;
  final int? id;

  @override
  String toString() {
    return "Instance of DataBaseNoteListItem; ID: $id, DONE: $done, NAME: $text";
  }
}
