import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth_service.dart';
import 'edit_workout_screen.dart';
import '../login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _customExerciseController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  late final String userId;
  String _selectedExercise = 'Push Up';

  final List<String> _exerciseOptions = [
    'Push Up',
    'Squat',
    'Bench Press',
    'Deadlift',
    'Plank',
    'Pull Up',
    'Custom'
  ];

  @override
  void initState() {
    super.initState();
    userId = AuthService().currentUser!.uid;
  }

  Future<void> _addWorkout({String? workoutId}) async {
    final String finalExercise = _selectedExercise == 'Custom'
        ? _customExerciseController.text
        : _selectedExercise;

    if (finalExercise.isEmpty) return;

    final workout = {
      'exercise': finalExercise,
      'sets': _setsController.text,
      'reps': _repsController.text,
      'weight': _weightController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(workoutId);

    if (workoutId == null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .add(workout);
    } else {
      await docRef.update(workout);
    }

    _customExerciseController.clear();
    _setsController.clear();
    _repsController.clear();
    _weightController.clear();
    setState(() => _selectedExercise = 'Push Up');
  }

  Future<void> _deleteWorkout(String workoutId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .doc(workoutId)
        .delete();
  }

  void _logout() async {
    await AuthService().signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Workout Log', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          )
        ],
      ),
      body: Column(
        children: [
          _buildInputForm(),
          const Divider(color: Colors.grey),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(userId)
                  .collection('workouts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading workouts', style: TextStyle(color: Colors.white)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No workouts yet', style: TextStyle(color: Colors.white)),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final sets = int.tryParse(data['sets'] ?? '') ?? 0;
                    final reps = int.tryParse(data['reps'] ?? '') ?? 0;
                    final weight = double.tryParse(data['weight'] ?? '') ?? 0;
                    final volume = sets * reps * weight;

                    return ListTile(
                      title: Text(data['exercise'] ?? '',
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        'Sets: ${data['sets']}, Reps: ${data['reps']}, Weight: ${data['weight']}\nVolume: $volume',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.amber),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditWorkoutScreen(
                                    workoutData: data,
                                    onSave: (updatedData) => _firestore
                                        .collection('users')
                                        .doc(userId)
                                        .collection('workouts')
                                        .doc(doc.id)
                                        .update(updatedData),
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteWorkout(doc.id),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedExercise,
            dropdownColor: Colors.black,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Select Exercise',
              labelStyle: TextStyle(color: Colors.lightGreenAccent),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreenAccent),
              ),
            ),
            items: _exerciseOptions.map((exercise) {
              return DropdownMenuItem(
                value: exercise,
                child: Text(exercise),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedExercise = value ?? 'Push Up');
            },
          ),
          if (_selectedExercise == 'Custom')
            _buildInput(_customExerciseController, 'Custom Exercise'),
          _buildInput(_setsController, 'Sets', isNumber: true),
          _buildInput(_repsController, 'Reps', isNumber: true),
          _buildInput(_weightController, 'Weight / Duration'),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreenAccent,
              foregroundColor: Colors.black,
            ),
            onPressed: _addWorkout,
            child: const Text('Add Workout'),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.lightGreenAccent),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.lightGreenAccent),
          ),
        ),
      ),
    );
  }
}
