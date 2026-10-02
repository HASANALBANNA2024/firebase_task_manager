import 'package:firebase_task_manager/core/riverpod_provider/add_task_provider.dart';
import 'package:firebase_task_manager/core/widgets/user_profile_header.dart';
import 'package:firebase_task_manager/features/home/widgets/task_filter_chip.dart';
import 'package:firebase_task_manager/features/home/widgets/task_list_widget.dart';
import 'package:firebase_task_manager/features/home/widgets/task_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(selectedFilterProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserProfileHeader(),
            const SizedBox(height: 24),
            const TaskProgressCard(),
            const SizedBox(height: 24),

            /// Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TaskFilterChip(
                    label: "All",
                    isSelected: currentFilter == "All",
                    onTap: () => ref
                        .read(selectedFilterProvider.notifier)
                        .setFilter("All"),
                  ),
                  const SizedBox(width: 10),
                  TaskFilterChip(
                    label: "Today",
                    isSelected: currentFilter == "Today",
                    onTap: () => ref
                        .read(selectedFilterProvider.notifier)
                        .setFilter("Today"),
                  ),
                  const SizedBox(width: 10),
                  TaskFilterChip(
                    label: "Work",
                    isSelected: currentFilter == "Work",
                    onTap: () => ref
                        .read(selectedFilterProvider.notifier)
                        .setFilter("Work"),
                  ),
                  const SizedBox(width: 10),
                  TaskFilterChip(
                    label: "Personal",
                    isSelected: currentFilter == "Personal",
                    onTap: () => ref
                        .read(selectedFilterProvider.notifier)
                        .setFilter("Personal"),
                  ),
                  const SizedBox(width: 10),
                  TaskFilterChip(
                    label: "Study",
                    isSelected: currentFilter == "Study",
                    onTap: () => ref
                        .read(selectedFilterProvider.notifier)
                        .setFilter("Study"),
                  ),
                  const SizedBox(width: 10),
                  TaskFilterChip(
                    label: "Health",
                    isSelected: currentFilter == "Health",
                    onTap: () => ref
                        .read(selectedFilterProvider.notifier)
                        .setFilter("Health"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const TaskListWidget(),
          ],
        ),
      ),
    );
  }
}
