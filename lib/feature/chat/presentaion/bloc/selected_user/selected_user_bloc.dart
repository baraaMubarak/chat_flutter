import 'package:bloc/bloc.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';
import 'package:meta/meta.dart';

part 'selected_user_event.dart';
part 'selected_user_state.dart';

class SelectedUserBloc extends Bloc<SelectedUserEvent, SelectedUserState> {
  SelectedUserBloc() : super(SelectedUserInitialState()) {
    on<SelectedUserEvent>((event, emit) {
      if (event is ChangeSelectedUserEvent) {
        emit(SelectedUserChangeState(user: event.user));
      } else if (event is ResetSelectedUserEvent) {
        emit(SelectedUserInitialState());
      }
    });
  }
}
