import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../workout_db.dart';
import '../workout.dart';

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({super.key});

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final data = await WorkoutDatabase.instance.getAllWorkouts();
    setState(() {
      _workouts = data;
    });
  }

  Future<void> _addWorkout() async {
    final workout = Workout(
      id: const Uuid().v4(),
      exercise: _exerciseController.text,
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
      weight: double.parse(_weightController.text),
      date: DateTime.now(),
    );

    await WorkoutDatabase.instance.insertWorkout(workout);
    await _syncToFirestore(workout);
    _loadWorkouts();

    _exerciseController.clear();
    _setsController.clear();
    _repsController.clear();
    _weightController.clear();
  }

  Future<void> _syncToFirestore(Workout workout) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .doc(workout.id);

    await ref.set(workout.toMap());
  }

  Future<void> _deleteWorkout(String id) async {
    await WorkoutDatabase.instance.deleteWorkout(id);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('workouts')
          .doc(id);
      await ref.delete();
    }
    _loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Log')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(controller: _exerciseController, decoration: const InputDecoration(labelText: 'Exercise')),
                TextField(controller: _setsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Sets')),
                TextField(controller: _repsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Reps')),
                TextField(controller: _weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Weight (kg)')),
                ElevatedButton(onPressed: _addWorkout, child: const Text('Add Workout')),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                final w = _workouts[index];
                return ListTile(
                  title: Text('${w.exercise} (${w.sets}x${w.reps}) - ${w.weight}kg'),
                  subtitle: Text(w.date.toLocal().toString().split('.')[0]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteWorkout(w.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
