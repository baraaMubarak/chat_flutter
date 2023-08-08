import 'package:bloc/bloc.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';
import 'package:meta/meta.dart';

part 'gender_event.dart';
part 'gender_state.dart';

class GenderBloc extends Bloc<GenderEvent, GenderState> {
  GenderBloc() : super(GenderInitial()) {
    on<GenderEvent>((event, emit) {
      if (event is ChangeGenderEvent) {
        emit(ChangedGenderState(gender: event.newGender));
      }
    });
  }
}
