class Note {
  int _id;
  String _title;
  String _date;
  String _description;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get id => _id;

  String get title => _title;

  String get date => _date;

  String get description => description;

  int get priority => _priority;

  set title(String title) {
    if (title.length <= 255) {
      this._title = title;
    } else {
      this._title = title.substring(0, 255);
    }
  }

  set description(String description) {
    if (description.length <= 255) {
      this._description = description;
    } else {
      this._description = description.substring(0, 255);
    }
  }

  set date(String date) {
    this._date = date.substring(0, 255);
  }

  set priority(int priority) {
    if (priority >= 1 && priority <= 3) {
      this._priority = priority;
    } else {
      this._priority = 2; // forced to medium
    }
  }

  Map<String,dynamic> toMap(){

    var note_map = Map<String,dynamic>();

    note_map['id'] = _id != null ? _id:0;
    note_map['title'] = _title;
    note_map['description'] = _description;
    note_map['date'] = _date;
    note_map['priority'] = _priority;

    return note_map;
  }

  Note.fromMapObject(Map<String,dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._priority = map['priority'];
  }

}
