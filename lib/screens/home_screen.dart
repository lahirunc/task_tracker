import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/screens/create_task_screen.dart';
import 'package:task_tracker/utils/local_storage.dart';

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
    String name = LocalStorage.readString('name') ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Tracker'),
      ),
      body: Column(
        children: [
          // hello user
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Hello $name',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController textEditingController =
                            TextEditingController();

                        final GlobalKey<FormState> formKey =
                            GlobalKey<FormState>();

                        return AlertDialog(
                          content: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: textEditingController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Cannot be empty!';
                                    }
                                    return null;
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text('Save'),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await LocalStorage.saveString('name',
                                              textEditingController.text)
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
          // task title
          Card(
            child: ListTile(
              title: const Text('Task Hello World'),
              trailing: Checkbox(
                value: true,
                onChanged: (value) {},
              ),
            ),
          ),
        ],
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
