import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/group_cubit/group_cubit.dart';
import '../models/group_model.dart';
import '../models/mode_model.dart';
import '../models/student_model.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
      return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(title: const Text('Groups'), backgroundColor: theme.colorScheme.surface, elevation: 0, foregroundColor: theme.colorScheme.onSurface),
      body: BlocBuilder<GroupCubit, List<GroupModel>>(
        builder: (context, groups) {
          return groups.isEmpty
              ? Center(
                  child: Text(
                    'No groups yet. Tap the + button to add a new group.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: groups.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return GroupCard(group: group);
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final groupCubit = context.read<GroupCubit>();
          showDialog(
            context: context,
            builder: (context) {
              String newGroupName = '';
              return AlertDialog(
                title: const Text('Add New Group'),
                content: TextField(
                  onChanged: (value) => newGroupName = value,
                  decoration: const InputDecoration(
                    hintText: 'Enter group name',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (newGroupName.isNotEmpty) {
                        groupCubit.createGroup(newGroupName);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final GroupModel group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nonMembers = students
        .where((s) => !group.students.contains(s))
        .toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DropdownButton<ModeModel?>(
                value: group.mode,
                underline: const SizedBox(),
                hint: Text('Class Default', style: theme.textTheme.labelLarge),
                items: [
                  DropdownMenuItem<ModeModel?>(
                    value: null,
                    child: Text(
                      'Class Default',
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                  ...modes.map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.name, style: theme.textTheme.labelLarge),
                    ),
                  ),
                ],
                onChanged: (selectedMode) {
                  context.read<GroupCubit>().assignMode(group, selectedMode);
                },
              ),
              SizedBox(width: 12),
              FilledButton(
                onPressed: () {
                  context.read<GroupCubit>().removeGroup(group);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                  minimumSize: const Size(36, 36),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Icon(
                  Icons.delete,
                  size: 20,
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Members',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final student in group.students)
                ActionChip(
                  avatar: Icon(
                    Icons.close,
                    size: 16,
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                  label: Text(student.name),
                  backgroundColor: theme.colorScheme.tertiaryContainer,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onTertiaryContainer,
                    fontSize: 13,
                  ),
                  side: BorderSide.none,
                  onPressed: () {
                    context.read<GroupCubit>().moveStudentToGroup(
                      student,
                      null,
                    );
                  },
                ),
              if (group.students.isEmpty)
                Text(
                  'No students yet',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Add from class',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final student in nonMembers)
                ActionChip(
                  avatar: Icon(
                    Icons.add,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  label: Text(
                    student.group != null
                        ? '${student.name} · in ${student.group!.name}'
                        : student.name,
                  ),
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                  side: BorderSide.none,
                  onPressed: () {
                    context.read<GroupCubit>().moveStudentToGroup(
                      student,
                      group,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
