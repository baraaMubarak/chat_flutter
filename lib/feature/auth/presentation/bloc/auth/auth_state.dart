part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String message;

  ErrorAuthState({required this.message});
}

class SuccessAuthState extends AuthState {
  final User user;

  SuccessAuthState({required this.user});
}

class SuccessRegisterAuthState extends AuthState {
  final User user;

  SuccessRegisterAuthState({required this.user});
}

class SuccessVerifyCodeAuthState extends AuthState {
  final User user;

  SuccessVerifyCodeAuthState({required this.user});
}

class SuccessLoginAuthState extends AuthState {
  final User user;

  SuccessLoginAuthState({required this.user});
}

class SuccessResetPasswordAuthState extends AuthState {
  final User user;

  SuccessResetPasswordAuthState({required this.user});
}

class SuccessSendCodeAuthState extends AuthState {
  final String message;

  SuccessSendCodeAuthState({required this.message});
}
