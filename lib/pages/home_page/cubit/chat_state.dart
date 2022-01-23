part of 'chat_cubit.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<AudioMessage> messages,
    @Default(false) bool isPlaying,
    @Default(true) bool isVolumeOn,
  }) = _State;
}
