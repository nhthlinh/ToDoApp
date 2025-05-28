import 'package:to_do_app/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TaskRepository {

  Future<void> addTask(TaskModel task) async {
    // Tạo document mới và lấy ID
    final docRef = FirebaseFirestore.instance.collection('tasks').doc();

    // Gán ID vừa sinh vào task
    final newTask = task.copyWith(id: docRef.id);

    // Ghi vào Firestore
    await docRef.set(newTask.toJson());
  }

  Future<List<TaskModel>> getTasks(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return TaskModel.fromJson(doc.data());
    }).toList();
  }


  Future<void> updateTask(TaskModel task) async {
    await FirebaseFirestore.instance.collection('tasks').doc(task.id.toString()).update(task.toJson());
  }

  Future<void> deleteTask(String id) async {
    await FirebaseFirestore.instance.collection('tasks').doc(id.toString()).delete();
  }
}