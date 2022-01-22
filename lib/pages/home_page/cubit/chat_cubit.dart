import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:int20h_app/constants.dart';
import 'package:int20h_app/services/dialogue_service.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._dialogueService) : super(ChatState()) {
    _messagesSubscription = _dialogueService.messagesStream.listen((event) {
      print(event);
    });
  }

  final DialogueService _dialogueService;

  @override
  Future<void> close() {
    _messagesSubscription.cancel();

    return super.close();
  }

  late final StreamSubscription<Message> _messagesSubscription;

  void loadMessages() {
    final messages = [
      TextMessage(
        author: aiUser,
        id: '1',
        text: 'sdfsdf',
      ),
    ];
    emit(state.copyWith(messages: messages));
  }

  Future<void> sendMessage(String message) async {
    _dialogueService.sendMessage(message);

    emit(state.copyWith(
      messages: [
        TextMessage(author: myUser, id: '2', text: message),
        ...state.messages,
      ],
    ));
  }
}
