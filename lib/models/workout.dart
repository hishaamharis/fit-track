class Workout {
  final String name;
  final int reps;
  final DateTime date;

  Workout({
    required this.name,
    required this.reps,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'reps': reps,
    'date': date.toIso8601String(),
  };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    name: json['name'],
    reps: json['reps'],
    date: DateTime.parse(json['date']),
  );
}