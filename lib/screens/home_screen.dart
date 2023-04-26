import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/screens/create_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    firestore.collection("tasks").snapshots().listen((QuerySnapshot event) {
      for (var task in event.docs) {
        print(task.data());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Tracker'),
      ),
      body: Card(
        child: ListTile(
          title: const Text('Task Hello World'),
          trailing: Checkbox(
            value: true,
            onChanged: (value) {},
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
