import 'dart:convert';

import 'package:chat/core/errors/exceptions.dart';
import 'package:chat/core/network/network_info.dart';
import 'package:chat/core/shared_pref/shared_pref.dart';
import 'package:chat/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:chat/injection_container.dart' as di;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiController {
  static ApiController instance = ApiController._internal();
  AuthLocalDataSource authLocalDataSource = di.sl<AuthLocalDataSource>();
  NetworkInfo networkInfo = di.sl<NetworkInfo>();
  SharedPrefController sharedPrefController = SharedPrefController();

  ApiController._internal() {
    cacheData = jsonDecode(sharedPrefController.get(key: 'CACHE_API') ?? '{}');
  }

  factory ApiController() {
    return instance;
  }

  Map<String, dynamic> cacheData = {};

  Future<Map> get(Uri url, {Map<String, String>? headers, int numberOfSecondsToSave = 0}) async {
    if (cacheData.keys.contains(url.toString())) {
      if (timeIsNotExpires(url)) {
        return cacheData[url.toString()];
      }
    }
    Map<String, String>? header = await sharedHeader(headers);
    http.Response response = await http.get(url, headers: header);
    Map<String, dynamic> data = await jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (numberOfSecondsToSave > 0) {
        cacheData[url.toString()] = data;
        cacheData['${url}cacheTime'] = numberOfSecondsToSave;
        cacheData['${url}saveTime'] = DateTime.now().toString();
        sharedPrefController.save(key: 'CACHE_API', value: jsonEncode(cacheData));
      }
      if (data.keys.contains('token')) {
        authLocalDataSource.saveToken(data['token']);
      }
      return data;
    } else {
      throw ServerException(message: data['message']);
    }
  }

  bool timeIsNotExpires(Uri url) {
    DateTime now = DateTime.now();
    DateTime timeExpires = DateTime.parse(cacheData['${url}saveTime']);
    return now.difference(timeExpires).inSeconds > 0;
  }

  Future<Map<String, dynamic>> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    Map<String, String>? header = await sharedHeader(headers);
    http.Response response = await http.post(url, headers: header, body: body, encoding: encoding);
    Map<String, dynamic> data = await jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data.keys.contains('token')) {
        authLocalDataSource.saveToken(data['token']);
      }
      return data['data'] ?? {};
    } else {
      throw ServerException(message: data['message']);
    }
  }

  Future<Map<String, dynamic>> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    required BuildContext context,
  }) async {
    Map<String, String>? header = await sharedHeader(headers);
    http.Response response = await http.patch(url, headers: header ?? {"Content-Type": "application/json"}, body: body, encoding: encoding);
    Map<String, dynamic> data = await jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data.keys.contains('token')) {
        authLocalDataSource.saveToken(data['token']);
      }
      return data;
    } else {
      throw ServerException(message: data['message']);
    }
  }

  Future<Map<String, dynamic>> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    Map<String, String>? header = await sharedHeader(headers);
    http.Response response = await http.put(
      url,
      headers: header,
      body: body,
      encoding: encoding,
    );
    Map<String, dynamic> data = await jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data.keys.contains('token')) {
        authLocalDataSource.saveToken(data['token']);
      }
      return data;
    } else {
      throw ServerException(message: data['message']);
    }
  }

  Future<Map<String, dynamic>> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    Map<String, String>? header = await sharedHeader(headers);
    http.Response response = await http.delete(url, headers: header, body: body, encoding: encoding);
    Map<String, dynamic> data = await jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data.keys.contains('token')) {
        authLocalDataSource.saveToken(data['token']);
      }
      return data;
    } else {
      throw ServerException(message: data['message']);
    }
  }

  Future<Map<String, String>?> sharedHeader(Map<String, String>? headers) async {
    await preCondition();

    Map<String, String>? header;
    if (authLocalDataSource.getToken() != null) {
      header = {
        'Authorization': 'Bearer ${authLocalDataSource.getToken()}',
      };
      header.addAll(headers ?? {});
    }
    return header;
  }

  Future<void> preCondition() async {
    if (!(await networkInfo.isConnected)) {
      throw OfflineException();
    }
  }
}
