import 'package:flutter/material.dart';

class DataBaseNote {
  final int? id;
  final String text;
  final String title;
  final IconData iconData;
  final DateTime date;
  final DateTime rememberdate;

  DataBaseNote(this.text, this.title, this.iconData, this.date,
      this.rememberdate, this.id);
}
