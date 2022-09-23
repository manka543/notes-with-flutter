class DataBaseNote {
  final int? id;
  final String text;
  final String title;
  final String favourite;
  final DateTime date;
  late final DateTime? rememberdate;
  final String? listName;
  final List<DataBaseNoteListItem>? listItems;

  DataBaseNote({
    required this.title,
    required this.text,
    required this.favourite,
    required this.date,
    this.rememberdate,
    this.id,
    this.listName,
    this.listItems,
  });

  @override
  String toString() {
    return ("Instance of DataBaseNote; ID: $id, TITLE: $title, TEXT: $text, FAVOURITE: $favourite, DATE: $date, REMEMBERDATE: $rememberdate, LISTNAME: $listName, LISTITEMS: $listItems");
  }
}

class DataBaseNoteListItem {
  const DataBaseNoteListItem(this.text, this.done, this.id);
  final String? text;
  final bool done;
  final int? id;

  @override
  String toString(){
    return "Instance of DataBaseNoteListItem; ID: $id, DONE: $done, NAME: $text";
  }
}