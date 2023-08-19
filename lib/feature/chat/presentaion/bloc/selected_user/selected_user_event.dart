part of 'selected_user_bloc.dart';

@immutable
abstract class SelectedUserEvent {}

class ChangeSelectedUserEvent extends SelectedUserEvent {
  final User user;

  ChangeSelectedUserEvent({required this.user});
}

class ResetSelectedUserEvent extends SelectedUserEvent {
  ResetSelectedUserEvent();
}
