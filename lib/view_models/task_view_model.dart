import 'package:flutter/material.dart';
import 'package:to_do_app/models/task_model.dart' show TaskModel;
import 'package:to_do_app/repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  final List<TaskModel> _tasks = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Load tất cả tasks từ Firestore
  Future<void> fetchTasks(String userId) async {
    print(userId);
    _isLoading = true;
    notifyListeners();
    final result = await _taskRepository.getTasks(userId);
    _tasks.clear();
    _tasks.addAll(result);
    _isLoading = false;
    notifyListeners();
  }

  /// Thêm task mới
  Future<void> addTask(TaskModel task) async {
    await _taskRepository.addTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  /// Xóa task
  Future<void> deleteTask(String id) async {
    await _taskRepository.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  /// Cập nhật task
  Future<void> updateTask(TaskModel updatedTask) async {
    await _taskRepository.updateTask(updatedTask);
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  /// Lọc task theo trạng thái hoàn thành
  List<TaskModel> getTasks() {
    return _tasks.toList();
  }

  List<TaskModel> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  List<TaskModel> getPendingTasks() {
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  int getTasksLength() {
    return _tasks.length;
  }

  List<TaskModel> getTasksByFilter(DateTime day, String filter) {
    return _tasks.where((task) {
      // So sánh ngày (không so sánh giờ)
      final sameDay =
          task.beginAt.year <= day.year &&
          task.beginAt.month <= day.month &&
          task.beginAt.day <= day.day &&
          task.endAt.year >= day.year &&
          task.endAt.month >= day.month &&
          task.endAt.day >= day.day;

      switch (filter) {
        case 'All':
          return sameDay;
        case 'In progress':
          return sameDay && !task.isCompleted;
        case 'Done':
          return sameDay && task.isCompleted;
        case 'Work':
        case 'Office':
        case 'Personal':
        case 'Daily':
          return sameDay && task.category == filter;
        default:
          return sameDay; // fallback nếu filter không hợp lệ
      }
    }).toList();
  }

  List<TaskModel> getTasksByTime() {
    List<TaskModel> sortedTasks = getPendingTasks();

    sortedTasks.sort((a, b) {
      final totalDurationA = a.endAt.difference(a.beginAt).inSeconds.toDouble();
      final elapsedA = DateTime.now().difference(a.beginAt).inSeconds.toDouble();
      final progressA = (elapsedA / totalDurationA).clamp(0.0, 1.0);

      final totalDurationB = b.endAt.difference(b.beginAt).inSeconds.toDouble();
      final elapsedB = DateTime.now().difference(b.beginAt).inSeconds.toDouble();
      final progressB = (elapsedB / totalDurationB).clamp(0.0, 1.0);
      
      return progressB.compareTo(progressA);
    });
    return sortedTasks;
  }

  List<TaskModel> getTasksByCategory(String category, bool checkComplete) {
    return _tasks
        .where((task) => task.category == category && task.isCompleted == checkComplete)
        .toList();
  }
}
