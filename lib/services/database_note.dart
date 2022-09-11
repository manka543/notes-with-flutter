class DataBaseNote {
  final int? id;
  final String text;
  final String title;
  final String icon;
  final DateTime date;
  late final DateTime? rememberdate;

  DataBaseNote({ required this.title, required this.text, required this.icon, required this.date,
      this.rememberdate, this.id});

  @override
  String toString(){
    return("Instance of DataBaseNote; ID: $id, TITLE: $title, TEXT: $text, IconData: $icon, Date: $date, RememberDate: $rememberdate");
  }
}
