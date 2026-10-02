import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/riverpod_provider/add_task_provider.dart';

class TaskProgressCard extends ConsumerWidget {
  const TaskProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(userTaskStreamProvider);

    return tasksAsync.when(
      data: (snapshot) {
        final docs = snapshot.docs;
        final totalTasks = docs.length;

        final completedTasks = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return data['isCompleted'] == true;
        }).length;

        final double progressPercent = totalTasks == 0
            ? 0.0
            : (completedTasks / totalTasks);
        final int percentInt = (progressPercent * 100).toInt();
        final int leftTasks = totalTasks - completedTasks;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0B132B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: progressPercent,
                      backgroundColor: Colors.white24,
                      color: const Color(0xFF00BFA5),
                      strokeWidth: 8,
                    ),
                    Center(
                      child: Text(
                        "$percentInt%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$completedTasks of $totalTasks tasks done today",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$leftTasks left. Keep up the good work!",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF0B132B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
        ),
      ),
      error: (_, __) => const SizedBox(),
    );
  }
}
