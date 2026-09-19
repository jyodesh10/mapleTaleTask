import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maple_tales_task/models/group_model.dart';
import 'package:maple_tales_task/models/student_model.dart';

import '../../models/mode_model.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<List<GroupModel>> {
  GroupCubit() : super(List.of(groups));

  void createGroup(String name) {
    final newGroup = GroupModel(id: state.length + 1, name: name);
    emit([...state, newGroup]);
  }

  void assignMode(GroupModel group, ModeModel? mode) {
    group.mode = mode;
    emit([...state]); // new list reference so BlocBuilder rebuilds
  }

  void removeGroup(GroupModel group) {
    for (var student in group.students) {
      student.group = null;
    }
    state.remove(group);
    emit([...state]);
  }

  void moveStudentToGroup(StudentModel student, GroupModel? targetGroup) {
    student.group?.students.remove(student);
    student.group = targetGroup;
    targetGroup?.students.add(student);
    emit([...state]);
  }

}
