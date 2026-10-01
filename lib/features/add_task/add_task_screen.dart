import 'package:firebase_task_manager/core/riverpod_provider/add_task_provider.dart';
import 'package:firebase_task_manager/core/widgets/app_input_decoration.dart';
import 'package:firebase_task_manager/core/widgets/app_message.dart';
import 'package:firebase_task_manager/core/widgets/app_text.dart';
import 'package:firebase_task_manager/core/widgets/category_selector.dart';
import 'package:firebase_task_manager/core/widgets/date_time_selector.dart';
import 'package:firebase_task_manager/core/widgets/priority_selector.dart';
import 'package:firebase_task_manager/core/widgets/remind_me.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskScreen extends ConsumerWidget {
  AddTaskScreen({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskFormProvider);
    final taskNotifier = ref.read(taskFormProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Color(0xFF101828)),
        ),
        title: Text(
          "New Task",
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF101828),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: "Title",
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF101828),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: customInputDecoration("Ex. Finish flutter dashboard"),
            ),
            const SizedBox(height: 16),
            const AppText(
              text: "Notes",
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF101828),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: customInputDecoration('Add details optional'),
            ),
            const SizedBox(height: 16),
            const AppText(
              text: "Category",
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF101828),
            ),
            const SizedBox(height: 8),
            CategorySelector(
              selectedCategory: taskState.category,
              onCategorySelected: (cat) {
                taskNotifier.setCategory(cat);
              },
            ),
            const SizedBox(height: 16),
            const AppText(
              text: "Priority",
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF101828),
            ),
            const SizedBox(height: 8),
            PrioritySelector(
              selectedPriority: taskState.priority,
              onPrioritySelected: (prio) {
                taskNotifier.setPriority(prio);
              },
            ),
            const SizedBox(height: 16),
            DateTimeSelector(
              selectedDate: taskState.date,
              selectedTime: taskState.time,
              onDateSelected: (date) {
                taskNotifier.setDate(date);
              },
              onTimeSelected: (time) {
                taskNotifier.setTime(time);
              },
            ),
            const SizedBox(height: 16),
            RemindMe(
              remindMe: taskState.remindMe,
              onChanged: (val) {
                taskNotifier.toggleRemindMe(val);
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E9F8E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: taskState.isLoading
                    ? null
                    : () async {
                        if (_titleController.text.trim().isEmpty) {
                          showCustomSnackBar(context, "Title cannot be empty");
                          return;
                        }
                        if (_notesController.text.trim().isEmpty) {
                          showCustomSnackBar(context, "Notes cannot be empty");
                          return;
                        }
                        bool success = await taskNotifier.saveTask(
                          title: _titleController.text.trim(),
                          notes: _notesController.text.trim(),
                        );
                        if (success) {
                          if (context.mounted) {
                            showCustomSnackBar(
                              context,
                              "Task added successfully",
                            );
                            Navigator.pop(context);
                          }
                        } else {
                          if (context.mounted) {
                            showCustomSnackBar(context, "Failed to add task!");
                          }
                        }
                      },
                child: taskState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Save task",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
