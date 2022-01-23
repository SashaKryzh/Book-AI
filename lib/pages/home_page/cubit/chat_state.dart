part of 'chat_cubit.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<AudioMessage> messages,
    @Default(true) bool isVolumeOn,
    BookType? bookType,
  }) = _State;
}
