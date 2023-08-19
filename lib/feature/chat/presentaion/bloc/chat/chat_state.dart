part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatSentMessageState extends ChatState {
  final String successMessage;

  ChatSentMessageState({required this.successMessage});
}

class ChatReceivedMessageState extends ChatState {
  final String successMessage;

  ChatReceivedMessageState({required this.successMessage});
}

class ChatErrorState extends ChatState {
  final String error;

  ChatErrorState({required this.error});
}
