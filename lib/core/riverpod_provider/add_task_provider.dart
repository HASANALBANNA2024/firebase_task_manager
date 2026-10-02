import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_task_manager/firebase/task_service/task_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskFormState {
  final String category;
  final String priority;
  final bool remindMe;
  final bool isLoading;
  final String date;
  final String time;
  TaskFormState({
    this.category = 'Work',
    this.priority = "Medium",
    this.remindMe = true,
    this.isLoading = false,
    this.date = "30 Sep",
    this.time = "4:30 PM",
  });
  TaskFormState copyWith({
    String? category,
    String? priority,
    bool? remindMe,
    bool? isLoading,
    String? date,
    String? time,
  }) {
    return TaskFormState(
      category: category ?? this.category,
      priority: priority ?? this.priority,
      remindMe: remindMe ?? this.remindMe,
      isLoading: isLoading ?? this.isLoading,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}

class TaskFormNotifier extends Notifier<TaskFormState> {
  @override
  TaskFormState build() {
    return TaskFormState();
  }

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  void setPriority(String priority) {
    state = state.copyWith(priority: priority);
  }

  void setDate(String date) {
    state = state.copyWith(date: date);
  }

  void setTime(String time) {
    state = state.copyWith(time: time);
  }

  void toggleRemindMe(bool value) {
    state = state.copyWith(remindMe: value);
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<bool> saveTask({required String title, required String notes}) async {
    setLoading(true);
    final taskService = ref.read(taskServiceProvider);
    bool success = await taskService.addTask(
      title: title,
      notes: notes,
      category: state.category,
      priority: state.priority,
      date: state.date,
      time: state.time,
      remindMe: state.remindMe,
    );
    setLoading(false);
    return success;
  }
}

final taskFormProvider =
    NotifierProvider.autoDispose<TaskFormNotifier, TaskFormState>(() {
      return TaskFormNotifier();
    });

final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService();
});

/// stream provider to fetch tasks in real-time for the UI
final userTaskStreamProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  final taskservice = ref.watch(taskServiceProvider);
  return taskservice.getUserTasks();
});

/// user profile data provider to fetch name, phone, email,
final userProfileProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((
  ref,
) async {
  final taskService = ref.watch(taskServiceProvider);
  return await taskService.getUserProfile();
});

/// filter chip Notifier
class FilterNotifier extends Notifier<String> {
  @override
  String build() {
    return "All";
  }

  void setFilter(String filter) {
    state = filter;
  }
}

final selectedFilterProvider = NotifierProvider<FilterNotifier, String>(() {
  return FilterNotifier();
});
