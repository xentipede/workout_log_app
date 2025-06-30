import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddWorkoutScreen extends StatelessWidget {
  const AddWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exerciseController = TextEditingController();
    final setsController = TextEditingController();
    final repsController = TextEditingController();
    final weightController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Workout')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: exerciseController, decoration: const InputDecoration(labelText: 'Exercise')),
            TextField(controller: setsController, decoration: const InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
            TextField(controller: repsController, decoration: const InputDecoration(labelText: 'Reps'), keyboardType: TextInputType.number),
            TextField(controller: weightController, decoration: const InputDecoration(labelText: 'Weight (kg or mins)'), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              onPressed: () {
                FirebaseFirestore.instance.collection('workouts').add({
                  'exercise': exerciseController.text,
                  'sets': setsController.text,
                  'reps': repsController.text,
                  'weight': weightController.text,
                  'userId': FirebaseAuth.instance.currentUser!.uid,
                  'timestamp': Timestamp.now(),
                });
                Navigator.pop(context);
              },
              child: const Text('Save Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
