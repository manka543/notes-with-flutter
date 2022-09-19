class DataBaseNote {
  final int? id;
  final String text;
  final String title;
  final String favourite;
  final DateTime date;
  late final DateTime? rememberdate;

  DataBaseNote(
      {required this.title,
      required this.text,
      required this.favourite,
      required this.date,
      this.rememberdate,
      this.id});

  @override
  String toString() {
    return ("Instance of DataBaseNote; ID: $id, TITLE: $title, TEXT: $text, FAVOURITE: $favourite, DATE: $date, REMEMBERDATE: $rememberdate");
  }
}
