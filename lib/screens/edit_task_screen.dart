import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  // accepting task data
  final TaskModel taskData;

  const EditTaskScreen({super.key, required this.taskData});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  // GlobalKey helps to identify the Form widget. This helps
  // to validate the form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // TextEditingController controller used to listen to the
  // changes of the TextFormField.
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // assigning default value to TextFormField
    textEditingController.text = widget.taskData.task!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),
      body: Form(
        // add the formKey here
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                // add text textEditingController here.
                controller: textEditingController,
                // validator is used to validate the data.
                validator: (String? value) {
                  // here you can check if the value is empty and
                  // show a message to stop the user from creating
                  // empty or null records .
                  if (value == null || value.isEmpty) {
                    return 'Cannot be empty!';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () async {
                  // if the form is valid then it will return true,
                  // else false.
                  if (formKey.currentState!.validate()) {
                    // update query for the task
                    await FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(widget.taskData.id)
                        .update({
                      'task': textEditingController.text,
                    }).then((value) => Navigator.pop(context));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
