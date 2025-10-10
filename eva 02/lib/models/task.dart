
class Task {
  String title;
  String? note;
  DateTime? due;
  bool done;
  double? valuation; 

  Task({
    required this.title,
    this.note,
    this.due,
    this.done = false,
    this.valuation, 
  });
}



