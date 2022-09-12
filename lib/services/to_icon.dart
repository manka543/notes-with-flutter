import 'package:flutter/material.dart';

IconData toIcon(String iconname) {
  switch (iconname) {
    case "share":
      return Icons.share;
    case "king_bed":
      return Icons.king_bed;
    case "thermostat_auto":
      return Icons.thermostat_auto;
    case "add_home_rounded":
      return Icons.add_home_rounded;
    default:
      return Icons.error;
  }
}
