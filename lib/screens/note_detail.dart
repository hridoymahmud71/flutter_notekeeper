import 'package:flutter/material.dart';

import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_notekeeper/models/note.dart';
import 'package:flutter_notekeeper/utils/database_helper.dart';
import 'package:flutter_notekeeper/utils/date_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  String appBarTitle = "";
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  var _priorities = ["High", "Medium", "Low"];
  var _defaultPriority = "";
  final Note currentNote;

  String barTitle = "";

  _NoteDetailState(this.currentNote, this.barTitle);

  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentNote!= null ? debugPrint(currentNote.toString()) : debugPrint("Note is null");
  }

  void setDefaultPriority() {
    this._defaultPriority = this._priorities[1]; //Medium
  }

  String _getDefaultPriority() {
    return this._defaultPriority;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = currentNote.title;
    descriptionController.text = currentNote.description;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(this.barTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                moveToLastScreen();
              },
            )),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              //first element
              ListTile(
                  title: DropdownButton(
                items: _priorities.map((String aPriotity) {
                  return DropdownMenuItem(
                    value: aPriotity,
                    child: Text(aPriotity),
                  );
                }).toList(),
                onChanged: (selectedPriority) {
                  setState(() {
                    debugPrint("User selected $selectedPriority");
                    updatePriority(priorityToInt(selectedPriority));
                  });
                },
                style: textStyle,
                value: priorityToString(currentNote.priority),
              )),

              //second element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint("Title changed .Change is $value");
                    updateTitle(value);
                  },
                  decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),

              // third element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint("Description changed .Change is $value");
                    updateDesctiption(value);
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),

              // fourth element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    //button 1
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "Save",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save clicked");
                            _save();
                          });
                        },
                      ),
                    ),

                    Container(
                      width: 5.0,
                    ),

                    //button 2
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          "delete",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete clicked");
                            _delete();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  //updates
  void updateTitle(String title) {
    currentNote.title = titleController.text;
  }

  void updateDesctiption(String description) {
    currentNote.description = descriptionController.text;
  }

  void updatePriority(int priority) {
    currentNote.priority = priority;
  }

  void _save() async {
    moveToLastScreen();
    currentNote.date = DateHelper.stringDateNow();
    int res;
    if (currentNote.id == null) {
      res = await databaseHelper.insertNote(currentNote);
    } else {
      res = await databaseHelper.updateNote(currentNote);
    }

    if (res == 0) {
      _showAlert("Problem", "Could not save the note");
    } else {
      _showAlert("Successful", "Note is saved");
    }
  }

  void _delete() async {
    moveToLastScreen();
    currentNote.date = DateHelper.stringDateNow();
    int res;
    if (currentNote.id == null) {
      _showAlert("Messaage", "Nothing to delete");
      return;
    }
    res = await databaseHelper.deleteNote(currentNote);

    if (res == 0) {
      _showAlert("Problem", "Could not delete the note");
    } else {
      _showAlert("Successful", "Note is deleted");
    }
  }

  void _showAlert(String status, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(status),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  //priority int to string
  int priorityToInt(String priority) {
    switch (priority) {
      case "High":
        return 3;
        break;
      case "Medium":
        return 2;
      case "Low":
        return 1;
      default:
        return 2;
    }
  }

  //priority string to int
  String priorityToString(int priority) {
    return priority >= 1 && priority <= 3
        ? _priorities[priority - 1]
        : _priorities[1]; //medium;
  }
}
