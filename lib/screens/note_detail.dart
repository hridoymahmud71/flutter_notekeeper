import 'package:flutter/material.dart';

import 'dart:async';
import 'package:sqflite/sql.dart';

import 'package:flutter_notekeeper/models/note.dart';
import 'package:flutter_notekeeper/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  String appBarTitle = "";

  NoteDetail(this.appBarTitle);

  @override
  _NoteDetailState createState() => _NoteDetailState(this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  var _priorities = ["High", "Medium", "Low"];
  var _defaultPriority = "";

  String barTitle = "";

  _NoteDetailState(this.barTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setDefaultPriority();
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
                  });
                },
                style: textStyle,
                value: this._getDefaultPriority(),
              )),

              //second element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint("Title changed .Change is $value");
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
    Navigator.pop(context);
  }
}
