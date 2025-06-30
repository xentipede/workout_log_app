class Workout {
  final String id;
  final String exercise;
  final int sets;
  final int reps;
  final double weight;
  final DateTime date;

  Workout({
    required this.id,
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercise': exercise,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'date': date.toIso8601String(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      exercise: map['exercise'],
      sets: map['sets'],
      reps: map['reps'],
      weight: map['weight'],
      date: DateTime.parse(map['date']),
    );
  }
}
