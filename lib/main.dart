import 'package:flutter/material.dart';
import 'package:flutter_notekeeper/screens/note_list.dart';
import 'package:flutter_notekeeper/screens/note_detail.dart';


void main(){
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My note app",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: NoteList(),
    );
  }
}



