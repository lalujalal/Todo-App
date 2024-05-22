import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:uuid/uuid.dart';

class AddTaskView extends StatefulWidget {
  final TaskModel? task;
  const AddTaskView({super.key, this.task});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _descripcontroller = TextEditingController();
  TaskService _taskService = TaskService();
  bool _edit = false;

  @override
  void dispose() {
    _titlecontroller.dispose();
    _descripcontroller.dispose();
    super.dispose();
  }

  loadData() {
    if (widget.task != null) {
      setState(() {
        _titlecontroller.text = widget.task!.title!;
        _descripcontroller.text = widget.task!.body!;
        _edit = true;
      });
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  final _taskKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Form(
          key: _taskKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _edit == true
                  ? Text(
                      "Update tasks",
                      style: ThemeData.textTheme.displayMedium,
                    )
                  : Text(
                      "Add tasks",
                      style: ThemeData.textTheme.displayMedium,
                    ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 2,
                color: Colors.teal,
                endIndent: 50,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                style: ThemeData.textTheme.displaySmall,
                controller: _titlecontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter title id mandatory';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    hintText: "enter the title",
                    hintStyle: ThemeData.textTheme.displaySmall,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: ThemeData.textTheme.displaySmall,
                controller: _descripcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'description is mandatory';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    hintText: "enter the description",
                    hintStyle: ThemeData.textTheme.displaySmall,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    )),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_taskKey.currentState!.validate()) {
                      if (_edit) {
                        TaskModel _taskModel = TaskModel(
                          id: widget.task?.id,
                          title: _titlecontroller.text,
                          body: _descripcontroller.text,
                        );
                        _taskService
                            .updateTask(_taskModel)
                            .then((value) => Navigator.pop(context));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('task updated')));
                      } else {
                        _addTask();
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _edit == true
                          ? Text(
                              'Update',
                              style: ThemeData.textTheme.displayMedium,
                            )
                          : Text(
                              'Add',
                              style: ThemeData.textTheme.displayMedium,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addTask() async {
    var id = const Uuid().v1();

    TaskModel _taskModel = TaskModel(
      title: _titlecontroller.text,
      body: _descripcontroller.text,
      id: id,
      status: 1,
      createdAt: DateTime.now(),
    );

    TaskService _taskService = TaskService();
    final task = await _taskService.createTask(_taskModel);

    if (task != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('task created')));
    }
  }
}
