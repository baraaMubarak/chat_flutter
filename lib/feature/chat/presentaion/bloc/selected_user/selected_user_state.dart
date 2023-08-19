part of 'selected_user_bloc.dart';

@immutable
abstract class SelectedUserState {}

class SelectedUserInitialState extends SelectedUserState {}

class SelectedUserChangeState extends SelectedUserState {
  final User user;

  SelectedUserChangeState({required this.user});
}
