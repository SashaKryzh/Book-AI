import 'package:flutter_chat_types/flutter_chat_types.dart';

class AudioMessage {
  String id;
  User user;
  String text;
  String? audioBase64;

  AudioMessage(
      {required this.id,
      required this.user,
      required this.text,
      this.audioBase64});
}
