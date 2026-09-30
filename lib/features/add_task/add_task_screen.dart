import 'package:firebase_task_manager/core/riverpod_provider/add_task_provider.dart';
import 'package:firebase_task_manager/core/widgets/app_message.dart';
import 'package:firebase_task_manager/core/widgets/app_text.dart';
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
          icon: Icon(Icons.arrow_back, color: Color(0xFF101828)),
        ),
        title: Text(
          "New Task",
          style: GoogleFonts.roboto(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF101828),
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
              decoration: _inputDecoration("Finish Flutter dashboard"),
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
              decoration: _inputDecoration("Add Details (optional)"),
            ),
            const SizedBox(height: 16),
            const AppText(
              text: "Category",
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF101828),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["Work", "Personal", "Study", "Health"].map((cat) {
                bool isSelected = taskState.category == cat;
                return GestureDetector(
                  onTap: () => taskNotifier.setCategory(cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0F1B2D)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0F1B2D)
                            : const Color(0xFFE4E9E8),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF667085),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            AppText(
              text: "Priority",
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF101828),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEBEFF0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: ["Low", "Medium", "High"].map((prio) {
                  bool isSelected = taskState.priority == prio;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => taskNotifier.setPriority(prio),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected
                              ? [
                                  const BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          prio,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFF101828)
                                : const Color(0xFF667085),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFE4E9E8),
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: Color(0xFF667085),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "30 Sep",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF101828),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Time",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFE4E9E8),
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 18,
                              color: Color(0xFF667085),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "4:30 PM",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF101828),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Remind Me Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE4E9E8), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Remind me",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF101828),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Push notification at the set time",
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: taskState.remindMe,
                    activeColor: const Color(0xFF0E9F8E),
                    onChanged: (val) => taskNotifier.toggleRemindMe(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            /// Save Task Button
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

                        taskNotifier.setLoading(true);

                        await Future.delayed(const Duration(seconds: 1));

                        taskNotifier.setLoading(false);
                        if (context.mounted) Navigator.pop(context);
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF98A2B3),
        fontWeight: FontWeight.normal,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE4E9E8), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF0E9F8E), width: 1.5),
      ),
    );
  }
}
