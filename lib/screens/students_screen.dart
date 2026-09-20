import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maple_tales_task/bloc/group_cubit/group_cubit.dart';
import 'package:maple_tales_task/bloc/search_cubit/search_cubit.dart';

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
      appBar: AppBar(
        title: const Text('Students'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return Column(
              children: [
                // Search Feature
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search students...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    onChanged: (query) {
                      context.read<SearchCubit>().searchStudents(query);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ).copyWith(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Student name', style: theme.textTheme.titleLarge),
                      Spacer(),
                      Text('Status', style: theme.textTheme.titleLarge),
                    ],
                  ),
                ),
                state is SearchLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state is SearchLoaded
                    ? state.results.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('No students found.'),
                              ),
                            )
                          : _buildStudentList(state.results, theme)
                    : _buildStudentList(students, theme),
              ],
            );
          },
        ),
      ),
    );
  }

  bool checkStudentInGroup(StudentModel student, List<GroupModel> groups) {
    for (var group in groups) {
      if (group.students.contains(student)) {
        return true;
      }
    }
    return false;
  }

  String getStudentGroupName(StudentModel student, List<GroupModel> groups) {
    for (var group in groups) {
      if (group.students.contains(student)) {
        return group.name;
      }
    }
    return '';
  }

  String getStudentModeName(StudentModel student, List<GroupModel> groups) {
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

  ListView _buildStudentList(List<StudentModel> students, ThemeData theme) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final student = students[index];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
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
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              BlocBuilder<GroupCubit, List<GroupModel>>(
                builder: (context, state) {
                  return _ModeBadge(
                    label: checkStudentInGroup(student, state)
                        ? '${getStudentModeName(student, state)} · ${getStudentGroupName(student, state)}'
                        : 'Class default',
                    color: checkStudentInGroup(student, state)
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.secondary,
                    bg: checkStudentInGroup(student, state)
                        ? theme.colorScheme.tertiaryContainer
                        : theme.colorScheme.secondaryContainer,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModeBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _ModeBadge({
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
