part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent implements AuthEvent {
  final String email, password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent implements AuthEvent {
  final User user;

  RegisterEvent({required this.user});
}

class SendCodeEvent implements AuthEvent {
  final String email;

  SendCodeEvent({required this.email});
}

class VerifyCodeEvent implements AuthEvent {
  final String code;

  VerifyCodeEvent({required this.code});
}

class ResetPasswordEvent implements AuthEvent {
  final String password;

  ResetPasswordEvent({required this.password});
}
