import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'nav_state.dart';

class NavCubit extends Cubit<int> {
  NavCubit() : super(0);


  void switchScreen(int index) {
    emit(index);
  }
}
