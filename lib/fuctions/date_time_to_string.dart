String? dateTimeToString(DateTime? dateTime) {
  if (dateTime != null) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute}";
  } else {
    return null;
  }
}
