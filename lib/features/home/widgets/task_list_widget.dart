import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/riverpod_provider/add_task_provider.dart';

class TaskListWidget extends ConsumerWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(userTaskStreamProvider);
    final currentFilter = ref.watch(selectedFilterProvider);

    return tasksAsync.when(
      data: (snapshot) {
        final docs = snapshot.docs;

        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                "No tasks found! Tap '+' to add a new task.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          );
        }

        /// filter logic
        final filteredDocs = docs.where((doc) {
          final taskData = doc.data() as Map<String, dynamic>;
          final category = taskData['category'] ?? '';
          final date = taskData['date'] ?? '';

          if (currentFilter == "All") {
            return true;
          } else if (currentFilter == "Today") {
            return date.toLowerCase().contains("today") || date == "02 Oct";
          } else if (currentFilter == "Work") {
            return category.toLowerCase() == "work";
          } else if (currentFilter == "Personal") {
            return category.toLowerCase() == "personal";
          } else if (currentFilter == "Health") {
            return category.toLowerCase() == "Health";
          } else if (currentFilter == "Study") {
            return category.toLowerCase() == "Study";
          }
          return true;
        }).toList();

        /// empty task after filter
        if (filteredDocs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                "No tasks found for '$currentFilter'!",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final taskData = filteredDocs[index].data() as Map<String, dynamic>;
            final taskId = filteredDocs[index].id;
            final title = taskData['title'] ?? '';
            final date = taskData['date'] ?? '';
            final time = taskData['time'] ?? '';
            final priority = taskData['priority'] ?? 'Medium';
            final isCompleted = taskData['isCompleted'] ?? false;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: isCompleted,
                    activeColor: const Color(0xFF00BFA5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (bool? value) async {
                      final taskService = ref.read(taskServiceProvider);
                      await taskService.updateTask(
                        taskId: taskId,
                        title: title,
                        notes: taskData['notes'] ?? '',
                        category: taskData['category'] ?? 'Work',
                        priority: priority,
                        date: date,
                        time: time,
                        remindMe: taskData['remindMe'] ?? false,
                        isCompleted: value ?? false,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isCompleted ? Colors.grey : Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isCompleted ? "Completed" : "$date, $time",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      priority,
                      style: TextStyle(
                        color: _getPriorityColor(priority),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
        ),
      ),
      error: (error, stack) => Center(child: Text("Error: $error")),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.amber[800]!;
      case 'low':
        return const Color(0xFF00BFA5);
      default:
        return Colors.blueGrey;
    }
  }
}
