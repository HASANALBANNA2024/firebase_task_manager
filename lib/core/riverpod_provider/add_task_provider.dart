import 'package:firebase_task_manager/firebase/task_service/task_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskFormState {
  final String category;
  final String priority;
  final bool remindMe;
  final bool isLoading;
  TaskFormState({
    this.category = 'Work',
    this.priority = "Medium",
    this.remindMe = true,
    this.isLoading = false,
  });
  TaskFormState copyWith({
    String? category,
    String? priority,
    bool? remindMe,
    bool? isLoading,
  }) {
    return TaskFormState(
      category: category ?? this.category,
      priority: priority ?? this.priority,
      remindMe: remindMe ?? this.remindMe,
      isLoading: isLoading ?? this.isLoading,
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

  void toggleRemindMe(bool value) {
    state = state.copyWith(remindMe: value);
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<bool> SaveTask({
    required String title,
    required String notes,
    required String date,
    required String time,
    required bool remindMe,
    required Ref ref,
  }) async {
    setLoading(true);
    final taskService = ref.read(taskServiceProvider);
    bool success = await taskService.addTask(
      title: title,
      notes: notes,
      category: state.category,
      priority: state.priority,
      date: date,
      time: time,
      remindMe: remindMe,
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
