class Task {
  final String title;
  final String date;
  final String time;
  final String _id;
  bool isDone;

  Task(this.title, this.date, this.time, this._id, {this.isDone = false});

  get id => _id;

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': date,
    'time': time,
    'id': _id,
    'isDone': isDone,
  };
}
