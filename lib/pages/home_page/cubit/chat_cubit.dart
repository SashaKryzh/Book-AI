import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:int20h_app/dto/audio_message.dart';
import 'package:int20h_app/services/dialogue_service.dart';

part 'chat_cubit.freezed.dart';
part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._dialogueService) : super(ChatState()) {
    _messagesSubscription = _dialogueService.messagesStream.listen(_addMessage);
  }

  final DialogueService _dialogueService;

  @override
  Future<void> close() {
    _messagesSubscription.cancel();

    return super.close();
  }

  late final StreamSubscription<AudioMessage> _messagesSubscription;

  void loadMessages() async {
    final messages = await _dialogueService.getMessages();
    // emit(state.copyWith(messages: [...messages]));
    emit(state.copyWith(messages: []));
  }

  Future<void> sendMessage(String message) async {
    _dialogueService.sendMessage(message);
  }

  void _addMessage(AudioMessage message) {
    // emit(state.copyWith(messages: [message, ...state.messages]));
    emit(state.copyWith(messages: [...state.messages]));
  }
}
