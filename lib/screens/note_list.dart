import 'package:flutter/material.dart';

import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_notekeeper/screens/note_detail.dart';
import 'package:flutter_notekeeper/models/note.dart';
import 'package:flutter_notekeeper/utils/database_helper.dart';
import 'package:flutter_notekeeper/utils/date_helper.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  void addDummyNotes() {
    List<Note> noteList = List<Note>();
    Note n1 = Note("A", DateHelper.stringDateNow(), 2);
    Note n2 = Note("fggdgdg", DateHelper.stringDateNow(), 1);
    Note n3 = Note("sdfsdf", DateHelper.stringDateNow(), 3);
    noteList.add(n1);
    noteList.add(n2);
    noteList.add(n3);

    this.noteList = noteList;
    this.count = noteList.length;
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("List of notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("FBA  pressed");
          navigateToDetail(Note('', '', 2), "Add A Note");
        },
        tooltip: "Add a note",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(
                this.noteList[position].title!=null ? this.noteList[position].title: "",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              subtitle: Text(this.noteList[position].description!=null?this.noteList[position].description:""),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onTap: () {
                  deleteNote(context, noteList[position]);
                  updateListView();
                },
              ),
              onTap: () {
                debugPrint("List title tapped");
                navigateToDetail(
                    Note(
                        this.noteList[position].title,
                        this.noteList[position].date,
                        this.noteList[position].priority),
                    "Edit the Note");
              },
            ),
          );
        });
  }

  void navigateToDetail(Note note, String title) async {
    bool res =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (res == true) {
      updateListView();
    }
  }

  void deleteNote(BuildContext context, Note note) async {
    var result = await databaseHelper.deleteNote(note);
    if (result != 0) {
      _showSnackbar(context, "Deleted Successfully");
    }
  }

  void updateListView() async {
    Future<Database> dbFuture = databaseHelper.initializeDb();
    dbFuture.then((database) {
      debugPrint("updateListView database, note=${this.noteList.toString()}");
      Future<List<Note>> futureNoteList = databaseHelper.getNoteList();
      futureNoteList.then((noteList) {
        debugPrint("updateListView futureNoteList, note=${this.noteList.toString()}");
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
          debugPrint("updateListView postload, note=${this.noteList.toString()}");
        });
      });
    });
  }

  //helper 1
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      case 3:
        return Colors.greenAccent;
        break;
      default:
        return Colors.lightBlue;
    }
  }

  //helper 2
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.arrow_drop_up);
        break;
      case 2:
        return Icon(Icons.trending_flat);
        break;
      case 3:
        return Icon(Icons.arrow_drop_down);
        break;
      default:
        return Icon(Icons.ac_unit);
    }
  }

  void _showSnackbar(BuildContext context, String txt) {
    final snackbar = SnackBar(content: Text(txt));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
