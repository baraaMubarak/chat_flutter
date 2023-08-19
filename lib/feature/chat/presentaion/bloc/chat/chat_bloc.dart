import 'package:bloc/bloc.dart';
import 'package:chat/core/errors/map_failure_to_string.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:chat/feature/chat/domain/usecases/send_message_usecase.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  SendMessageUseCase sendMessageUseCase;

  // late io.Socket socket;
  // final AuthLocalDataSource _authLocalDataSource = di.sl<AuthLocalDataSource>();

  ChatBloc({
    required this.sendMessageUseCase,
  }) : super(ChatInitialState()) {
    on<ChatEvent>((event, emit) async {
      if (event is ChatSendMessageEvent) {
        emit(ChatLoadingState());
        final failureOrUnit = await sendMessageUseCase(
          message: event.message,
          ack: (data) async {
            Future.delayed(
              const Duration(seconds: 1),
              () {
                if (emit.isDone && emit is ChatLoadingState) {
                  if (data['status'] == 201) {
                    emit(ChatSentMessageState(successMessage: data['message']));
                  } else {
                    emit(ChatErrorState(error: 'Un Expected Error In Socket'));
                  }
                }
              },
            );
          },
        );
        if (emit.isDone && emit is ChatLoadingState) {
          failureOrUnit.fold(
            (failure) => emit(ChatErrorState(error: mapFailureToString(failure))),
            (unit) => null,
          );
        }
      } else if (event is ChatReceivedMessageEvent) {
        emit(ChatLoadingState());
        emit(ChatReceivedMessageState(successMessage: ''));
      }
    });
  }
}
