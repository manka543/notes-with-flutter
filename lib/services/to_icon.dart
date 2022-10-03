import 'package:flutter/material.dart';

IconData toIcon(bool favourite) {
  switch (favourite) {
    case false:
      return Icons.star_outline_rounded;
    case true:
      return Icons.star_rounded;
    default:
      return Icons.error;
  }
}
