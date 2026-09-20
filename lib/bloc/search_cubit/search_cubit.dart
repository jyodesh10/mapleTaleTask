import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/student_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());


  void searchStudents(String query) {
    if (query.isEmpty) {
      emit(SearchInitial());
    } else {
      emit(SearchLoading());
      // Simulate a search operation
      // Future.delayed(const Duration(seconds: 1), () {
        List<StudentModel> results = students.where((student) => student.name.toLowerCase().contains(query.toLowerCase())).toList();
        emit(SearchLoaded(results: results));
      // });
    }
  }
}
