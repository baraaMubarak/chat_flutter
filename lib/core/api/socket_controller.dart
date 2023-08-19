import 'dart:async';

import 'package:chat/core/api/api_settings.dart';
import 'package:chat/core/errors/exceptions.dart';
import 'package:chat/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:chat/feature/chat/data/datat_source/chat_local_data_source.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:chat/feature/chat/presentaion/bloc/chat/chat_bloc.dart';
import 'package:chat/injection_container.dart' as di;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketController {
  static SocketController? _instance; // Make the instance nullable
  late io.Socket socket;
  final AuthLocalDataSource _authLocalDataSource = di.sl<AuthLocalDataSource>();
  final ChatLocalDataSource chatLocalDataSource = ChatLocalDataSourceImp();
  final BuildContext context;

  SocketController._internal({required this.context}) {
    _socketConnect();
  }

  static SocketController getInstance({BuildContext? context}) {
    _instance ??= SocketController._internal(context: context!);
    return _instance!;
  }

  _socketConnect() {
    socket = io.io(ApiSettings.BASE_URL, {
      'transports': ['websocket'],
      'autoConnect': false
    });
    _listeners();
    socket.connect();
  }

  sendMessage({
    required Message message,
    required void Function(dynamic data) ack,
  }) {
    if (_authLocalDataSource.getToken() == null) {
      throw NoUserException();
    }
    socket.emitWithAck(
      'message',
      {
        'receiverId': message.receiverId,
        'token': _authLocalDataSource.getToken(),
        'message': message.message,
      },
      ack: (data) {
        if (data != null) {
          ack(data);
          Logger().i('ACK: $data');
        } else {
          Logger().w('Null ACK');
        }
      },
    );
  }

  search({
    required String searchKey,
    required void Function(dynamic data) ack,
  }) async {
    if (_authLocalDataSource.getToken() == null) {
      throw NoUserException();
    }
    final completer = Completer<dynamic>();

    socket.emitWithAck(
      'search',
      {
        'socketId': socket.id,
        'searchKey': searchKey,
      },
      ack: (data) {
        if (data != null) {
          completer.complete(data);
          ack(data);
          Logger().i('ACK: $data');
        } else {
          completer.completeError('Null ACK');
          Logger().w('Null ACK');
        }
      },
    );
    try {
      final response = await completer.future;
      return response;
    } catch (error) {
      // Handle errors here
      throw Exception();
    }
  }

  // Stream<Message> listenForMessages(Function(dynamic data) callBack) async* {
  //   Logger().d('data');
  //   if (_authLocalDataSource.getUser() == null) {
  //     throw NoUserException();
  //   }
  //   socket.on(_authLocalDataSource.getUser()!.sid!, (data) {
  //     Logger().d(data);
  //     return callBack(data);
  //   });
  // }

  _listeners() {
    socket.onConnect((data) => Logger().i('The socket was successfully connected, ${socket.id}'));
    socket.onDisconnect((data) => Logger().w('Disconnected! $data'));
    socket.onConnectError((err) => Logger().e(err));
    socket.onError((err) => Logger().e(err));
    socket.on(_authLocalDataSource.getUser()!.sid!, (data) {
      chatLocalDataSource.saveMessage(
          Message(
            message: data['message'],
            senderId: data['senderId'],
            createdAt: data['createdAt'],
          ),
          data['senderId']);
      BlocProvider.of<ChatBloc>(context).add(ChatReceivedMessageEvent());
    });
  }
}
