class Habit {
  final int? id;
  final String title;
  final String description;
  final String date;
  final String time;

  Habit(
      {this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
    };
  }
}
