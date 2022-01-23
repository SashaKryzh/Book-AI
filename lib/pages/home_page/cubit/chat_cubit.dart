import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:int20h_app/dto/audio_message.dart';
import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/services/audio_service.dart';
import 'package:int20h_app/services/dialogue_service.dart';

part 'chat_cubit.freezed.dart';
part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._dialogueService) : super(ChatState()) {
    _messagesSubscription = _dialogueService.messagesStream.listen(_addMessage);
  }

  DialogueService _dialogueService;

  final audioService = AudioService();

  @override
  Future<void> close() {
    _messagesSubscription.cancel();

    return super.close();
  }

  late final StreamSubscription<AudioMessage> _messagesSubscription;

  void loadMessages() async {
    final messages = await _dialogueService.getMessages();
    emit(state.copyWith(messages: [...messages]));
  }

  Future<void> sendMessage(String message) async {
    _dialogueService.sendMessage(message);
  }

  void toggleVolume() {
    emit(state.copyWith(isVolumeOn: !state.isVolumeOn));
  }

  // TODO: delete
  void _addMessage(AudioMessage message) async {
    audioService.playMessageSound();

    emit(state.copyWith(bookType: BookType.burnout));
    return;

    if (message.finishConversation) {
      final bookType = _dialogueService.summary.bookType!;
      emit(state.copyWith(bookType: bookType));
    } else {
      emit(state.copyWith(messages: [message, ...state.messages]));
    }
  }

  void restart() {
    // TODO: reset dialog service;
    emit(ChatState());
  }
}
