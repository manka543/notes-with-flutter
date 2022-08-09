import 'package:flutter/material.dart';

class DataBaseNote {
  final String text;
  final String title;
  final Icon icon;
  final DateTime date;
  final DateTime rememberdate;

  DataBaseNote(this.text, this.title, this.icon, this.date, this.rememberdate);
}