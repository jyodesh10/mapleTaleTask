import 'mode_model.dart';
import 'student_model.dart';

class GroupModel {
  final int id;
  final String name;
  ModeModel? mode;
  List<StudentModel> students;

  GroupModel({required this.id, required this.name, this.mode, List<StudentModel>? students})
      : students = students ?? [];
}

List<GroupModel> groups = [
  GroupModel(id: 1, name: 'Group 1'),
  GroupModel(id: 2, name: 'Group 2'),
];