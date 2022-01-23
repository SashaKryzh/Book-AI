import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:int20h_app/dto/audio_message.dart';
import 'package:int20h_app/services/dialogue_service.dart';
import 'package:soundpool/soundpool.dart';

part 'chat_cubit.freezed.dart';
part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._dialogueService) : super(ChatState()) {
    _messagesSubscription = _dialogueService.messagesStream.listen(_addMessage);
  }

  final DialogueService _dialogueService;

  final soundpool = Soundpool.fromOptions();

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

  void _addMessage(AudioMessage message) {
    playMessage(message);
    // TODO: check for last message and request books
    emit(state.copyWith(messages: [message, ...state.messages]));
  }

  void playMessage(AudioMessage message) async {
    if (message.audioBytes == null || state.isPlaying) return;

    emit(state.copyWith(isPlaying: true));
    final soundId = await soundpool.loadAndPlayUint8List(message.audioBytes!);
    emit(state.copyWith(isPlaying: false));
  }
}
