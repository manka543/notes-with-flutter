import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  const Note({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Placeholder(color: Colors.red,strokeWidth: 45,child: TextButton(onPressed: (){},child: Text("i am doing nothing"),));
  }
}