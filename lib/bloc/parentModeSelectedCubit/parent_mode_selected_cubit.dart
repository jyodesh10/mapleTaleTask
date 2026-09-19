import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/mode_model.dart';

part 'parent_mode_selected_state.dart';

class ParentModeSelectedCubit extends Cubit<ParentModeSelectedState> {
  ParentModeSelectedCubit() : super(ParentModeSelectedInitial());

  setSelectedParentMode(ModeModel selectedMode) {
    // emit(ParentModeSelected(selectdMode));
  }
}
