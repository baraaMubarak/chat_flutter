import 'package:chat/core/network/network_info.dart';
import 'package:chat/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:chat/feature/auth/data/data_source/auth_remote_data_source.dart';
import 'package:chat/feature/auth/data/repository/auth_repository_imp.dart';
import 'package:chat/feature/auth/domain/repository/auth_repository.dart';
import 'package:chat/feature/auth/domain/usecases/login_usecase.dart';
import 'package:chat/feature/auth/domain/usecases/register_usecase.dart';
import 'package:chat/feature/auth/domain/usecases/reset_password_usecase.dart';
import 'package:chat/feature/auth/domain/usecases/send_code_usecase.dart';
import 'package:chat/feature/auth/domain/usecases/verify_code_usecase.dart';
import 'package:chat/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/feature/chat/data/datat_source/chat_local_data_source.dart';
import 'package:chat/feature/chat/data/datat_source/chat_remote_data_source.dart';
import 'package:chat/feature/chat/data/repository/chat_repository_imp.dart';
import 'package:chat/feature/chat/domain/repository/chat_repository.dart';
import 'package:chat/feature/chat/domain/usecases/get_previus_messages_usecase.dart';
import 'package:chat/feature/chat/domain/usecases/send_message_usecase.dart';
import 'package:chat/feature/chat/presentaion/bloc/chat/chat_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Feature - auth
  // bloc
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        sendCodeUseCase: sl(),
        resetPasswordUseCase: sl(),
        verifyCodeUseCase: sl(),
      ));

  // use case
  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SendCodeUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => VerifyCodeUseCase(authRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImp(
        authRemoteDataSource: sl(),
        authLocalDataSource: sl(),
        networkInfo: NetworkInfoImpl(),
      ));

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImp());
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImp());

  ///chat
  //Bloc
  sl.registerFactory(() => ChatBloc(
        sendMessageUseCase: sl(),
        getPreviousMessagesUseCase: sl(),
      ));

  // use case
  sl.registerLazySingleton(() => SendMessageUseCase(chatRepository: sl()));
  sl.registerLazySingleton(() => GetPreviousMessagesUseCase(chatRepository: sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImp(
        chatLocalDataSource: sl(),
        chatRemoteDataSource: sl(),
      ));

  // Data Source
  sl.registerLazySingleton<ChatLocalDataSource>(() => ChatLocalDataSourceImp());
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImp());

  /// core

  // network connection
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  /// External

  // sharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // http client
  // sl.registerLazySingleton(() => InternetConnectionChecker());
}
