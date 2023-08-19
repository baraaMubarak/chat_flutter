import 'package:chat/core/api/api_controller.dart';
import 'package:chat/core/api/api_settings.dart';
import 'package:chat/core/errors/exceptions.dart';
import 'package:chat/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:chat/feature/auth/data/model/user.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';

abstract class AuthRemoteDataSource {
  Future<User> register({required User user});

  Future<User> login({required String email, required String password});

  Future<void> sendCode({required String email});

  Future<User> verifyCode({required String code});

  Future<User> resetPassword({required String password});
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  ApiController apiController = ApiController();
  AuthLocalDataSource authLocalDataSource = AuthLocalDataSourceImp();
  AuthRemoteDataSourceImp();

  @override
  Future<User> login({required String email, required String password}) async {
    Map<String, dynamic> res = await apiController.post(
      Uri.parse(ApiSettings.BASE_URL + ApiSettings.LOGIN),
      body: {'email': email, 'password': password},
    );
    if (res.isEmpty) {
      throw EmailIsNotVerifiedException();
    }
    UserModel user = UserModel.fromJson(res);
    authLocalDataSource.saveUser(user);
    return user;
  }

  @override
  Future<User> register({required User user}) async {
    Map<String, dynamic> res = await apiController.post(
      Uri.parse(ApiSettings.BASE_URL + ApiSettings.REGISTER),
      body: {
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'gender': user.gender!.name,
        'dateOfBirth': user.dateOfBirth,
      },
    );
    UserModel newUser = UserModel.fromJson(res);
    authLocalDataSource.saveUser(newUser);
    return newUser;
  }

  @override
  Future<User> resetPassword({required String password}) async {
    Map<String, dynamic> res = await apiController.post(
      Uri.parse(ApiSettings.BASE_URL + ApiSettings.RESET_PASSWORD),
      body: {'password': password},
    );

    UserModel user = UserModel.fromJson(res);
    authLocalDataSource.saveUser(user);
    return user;
  }

  @override
  Future<void> sendCode({required String email}) async {
    await apiController.post(
      Uri.parse(ApiSettings.BASE_URL + ApiSettings.SEND_CODE),
      body: {'email': email},
    );
  }

  @override
  Future<User> verifyCode({required String code}) async {
    Map<String, dynamic> res = await apiController.post(
      Uri.parse(ApiSettings.BASE_URL + ApiSettings.VERIFY_CODE),
      body: {'code': code},
    );
    UserModel user = UserModel.fromJson(res);
    authLocalDataSource.saveUser(user);
    return user;
  }
}
