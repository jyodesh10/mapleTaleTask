import 'group_model.dart';

class StudentModel {
  final int id;
  final String name;
  GroupModel? group; // null = not in any group

  StudentModel({required this.id, required this.name, this.group});
}

List<StudentModel> students = [
  StudentModel(id: 1, name: 'Alice',),
  StudentModel(id: 2, name: 'Bob',),
  StudentModel(id: 3, name: 'Charlie',),
  StudentModel(id: 4, name: 'David',),
  StudentModel(id: 5, name: 'Eve', ),
  StudentModel(id: 6, name: 'Frank', ),
  StudentModel(id: 7, name: 'Grace',),
  StudentModel(id: 8, name: 'Heidi',),
  StudentModel(id: 9, name: 'Ivan', ),
  StudentModel(id: 10, name: 'Judy', ),
  StudentModel(id: 11, name: 'Karl', ),
  StudentModel(id: 12, name: 'Laura'),
  StudentModel(id: 13, name: 'Mallory'),
  StudentModel(id: 14, name: 'Niaj'),
  StudentModel(id: 15, name: 'Olivia'),
  StudentModel(id: 16, name: 'Peggy', ),
  StudentModel(id: 17, name: 'Quentin',),
  StudentModel(id: 18, name: 'Rupert',),
  StudentModel(id: 19, name: 'Sybil',),
  StudentModel(id: 20, name: 'Trent',),
];