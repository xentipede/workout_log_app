import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  const WorkoutCard({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade900,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(doc['exercise'], style: const TextStyle(color: Colors.lightGreenAccent)),
        subtitle: Text(
          'Sets: ${doc['sets']}  Reps: ${doc['reps']}  Weight: ${doc['weight']}',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => doc.reference.delete(),
        ),
      ),
    );
  }
}
