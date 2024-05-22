import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_model.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection("tasks");

  //create task

  Future<TaskModel?> createTask(TaskModel task) async {
    try {
      final taskMap = task.toMap();
      await _taskCollection.doc(task.id).set(taskMap);

      return task;
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }


  //update task

  Future <void> updateTask(TaskModel task)async{

    try{

      final taskMap=task.toMap();
      await _taskCollection.doc(task.id).update(taskMap);

    }on FirebaseException catch(e){
      print(e.toString());
    }

  }


  //delete task
  Future<void>deleteTask(String id)async{
    try{

      await _taskCollection.doc(id).delete();

    }on FirebaseException catch(e){
      print(e.toString());
    }
  }

}
