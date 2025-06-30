import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditWorkoutScreen extends StatefulWidget {
  final Map<String, dynamic> workoutData;
  final Function(Map<String, dynamic>) onSave;

  const EditWorkoutScreen({
    super.key,
    required this.workoutData,
    required this.onSave,
  });

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  late final TextEditingController _exerciseController;
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _exerciseController = TextEditingController(text: widget.workoutData['exercise']);
    _setsController = TextEditingController(text: widget.workoutData['sets']);
    _repsController = TextEditingController(text: widget.workoutData['reps']);
    _weightController = TextEditingController(text: widget.workoutData['weight']);
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _save() {
    final updated = {
      'exercise': _exerciseController.text,
      'sets': _setsController.text,
      'reps': _repsController.text,
      'weight': _weightController.text,
      'timestamp': FieldValue.serverTimestamp(),
    };
    widget.onSave(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edit Workout', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInput(_exerciseController, 'Exercise'),
            _buildInput(_setsController, 'Sets', isNumber: true),
            _buildInput(_repsController, 'Reps', isNumber: true),
            _buildInput(_weightController, 'Weight / Duration'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent,
                foregroundColor: Colors.black,
              ),
              onPressed: _save,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, {bool isNumber = false}) {
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
