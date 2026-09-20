import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maple_tales_task/models/group_model.dart';
import 'package:maple_tales_task/models/student_model.dart';

import '../../models/mode_model.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<List<GroupModel>> {
  GroupCubit() : super(List.of(groups));

  // Create a new group
  void createGroup(String name) {
    final newGroup = GroupModel(id: state.length + 1, name: name);
    emit([...state, newGroup]);
  }

  // Assign a mode to a group
  void assignMode(GroupModel group, ModeModel? mode) {
    group.mode = mode;
    emit([...state]); // new list reference so BlocBuilder rebuilds
  }

  // Remove a group and unassign its students
  void removeGroup(GroupModel group) {
    for (var student in group.students) {
      student.group = null;
    }
    state.remove(group);
    emit([...state]);
  }

  // Move a student to a different group
  void moveStudentToGroup(StudentModel student, GroupModel? targetGroup) {
    student.group?.students.remove(student);
    student.group = targetGroup;
    targetGroup?.students.add(student);
    emit([...state]);
  }

}
