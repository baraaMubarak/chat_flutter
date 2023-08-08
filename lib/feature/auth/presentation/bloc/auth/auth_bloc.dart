import 'package:bloc/bloc.dart';
import 'package:chat/core/errors/failures.dart';
import 'package:chat/core/errors/map_failure_to_string.dart';
import 'package:chat/core/strings/text.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';
import 'package:chat/feature/auth/domain/usecases/login_usecase.dart';
import 'package:chat/feature/auth/domain/usecases/register_usecase.dart';
import 'package:chat/feature/auth/domain/usecases/reset_password_usecase.dart';
import 'package:chat/feature/auth/domain/usecases/send_code_usecase.dart';
import 'package:chat/feature/auth/domain/usecases/verify_code_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  RegisterUseCase registerUseCase;
  LoginUseCase loginUseCase;
  ResetPasswordUseCase resetPasswordUseCase;
  SendCodeUseCase sendCodeUseCase;
  VerifyCodeUseCase verifyCodeUseCase;

  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.resetPasswordUseCase,
    required this.sendCodeUseCase,
    required this.verifyCodeUseCase,
  }) : super(InitialAuthState()) {
    on<AuthEvent>((event, emit) async {
      if (event is RegisterEvent) {
        emit(LoadingAuthState());
        final userOrStateFailure = await _bodiesWithoutSendCode(() => registerUseCase(user: event.user));
        if (userOrStateFailure is User) {
          emit(SuccessRegisterAuthState(user: userOrStateFailure));
        } else {
          emit(userOrStateFailure);
        }
      } else if (event is LoginEvent) {
        emit(LoadingAuthState());
        final userOrStateFailure = await _bodiesWithoutSendCode(() => loginUseCase(password: event.password, email: event.email));
        if (userOrStateFailure is User) {
          emit(SuccessLoginAuthState(user: userOrStateFailure));
        } else {
          emit(userOrStateFailure);
        }
      } else if (event is ResetPasswordEvent) {
        emit(LoadingAuthState());
        final userOrStateFailure = await _bodiesWithoutSendCode(() => resetPasswordUseCase(password: event.password));
        if (userOrStateFailure is User) {
          emit(SuccessResetPasswordAuthState(user: userOrStateFailure));
        } else {
          emit(userOrStateFailure);
        }
      } else if (event is VerifyCodeEvent) {
        emit(LoadingAuthState());
        final userOrStateFailure = await _bodiesWithoutSendCode(() => verifyCodeUseCase(code: event.code));
        if (userOrStateFailure is User) {
          emit(SuccessVerifyCodeAuthState(user: userOrStateFailure));
        } else {
          emit(userOrStateFailure);
        }
      } else if (event is SendCodeEvent) {
        emit(LoadingAuthState());
        final failureOrUser = await sendCodeUseCase(email: event.email);
        return failureOrUser.fold(
          (failure) => emit(ErrorAuthState(message: mapFailureToString(failure))),
          (user) => emit(SuccessSendCodeAuthState(message: SEND_CODE_SUCCESSFUL)),
        );
      }
    });
  }

  Future<dynamic> _bodiesWithoutSendCode(Future<Either<Failure, User>> Function() cb) async {
    final failureOrUser = await cb();
    return failureOrUser.fold(
      (failure) => ErrorAuthState(message: mapFailureToString(failure)),
      (user) => user,
    );
  }
}
