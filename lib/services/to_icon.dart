import 'package:flutter/material.dart';

IconData toIcon(String iconname){
  switch (iconname) {
    case "share":
      return Icons.share;
    default:
      return Icons.error;
  }
}