import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/models/task_model.dart';
import 'package:task_tracker/screens/create_task_screen.dart';
import 'package:task_tracker/screens/edit_task_screen.dart';
import 'package:task_tracker/utils/local_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // list that accept TaskModel
  List<TaskModel> taskList = [];

  @override
  void initState() {
    firestore.collection("tasks").snapshots().listen((QuerySnapshot event) {
      // clearing data in the list
      taskList.clear();

      for (var task in event.docs) {
        // converting the object into map
        Map<String, dynamic> taskMap = task.data() as Map<String, dynamic>;

        // adding task id
        taskMap['id'] = task.id;

        // set state to refresh the UI when the data is added
        setState(() {
          // adding TaskModel into task list
          taskList.add(TaskModel.fromJson(taskMap));
        });
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
          ListView.builder(
            shrinkWrap: true,
            itemCount: taskList.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(taskList[index].task!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: taskList[index].status,
                      onChanged: (value) async {
                        await firestore
                            .collection('tasks')
                            .doc(taskList[index].id)
                            .update({'status': value});
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditTaskScreen(taskData: taskList[index]),
                            ));
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await firestore
                            .collection('tasks')
                            .doc(taskList[index].id)
                            .delete();
                      },
                    ),
                  ],
                ),
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
