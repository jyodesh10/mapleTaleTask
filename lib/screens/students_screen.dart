import 'package:flutter/material.dart';

import '../models/group_model.dart';
import '../models/student_model.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(title: const Text('Students')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final student = students[index];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.5),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    _initials(student.name),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    student.name,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                _ModeBadge(
                  label: checkStudentInGroup(student) ? '${getStudentModeName(student)} · ${getStudentGroupName(student)}' : 'Class default',
                  color: checkStudentInGroup(student) ? theme.colorScheme.tertiary : theme.colorScheme.secondary,
                  bg: checkStudentInGroup(student)
                      ? theme.colorScheme.tertiaryContainer
                      : theme.colorScheme.secondaryContainer,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool checkStudentInGroup(StudentModel student) {
    for (var group in groups) {
      if (group.students.contains(student)) {
        return true;
      }
    }
    return false;
  }

  String getStudentGroupName(StudentModel student) {
    for (var group in groups) {
      if (group.students.contains(student)) {
        return group.name;
      }
    }
    return '';
  }

  String getStudentModeName(StudentModel student) {
    for (var group in groups) {
      if (group.students.contains(student)) {
        return group.mode?.name ?? 'Class Default';
      }
    }
    return 'Class Default';
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters = parts.take(2).map((p) => p.isNotEmpty ? p[0] : '').join();
    return letters.toUpperCase();
  }
}

class _ModeBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _ModeBadge({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}