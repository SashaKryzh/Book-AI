import 'dart:typed_data';

import 'package:flutter_chat_types/flutter_chat_types.dart';

class AudioMessage {
  String id;
  User user;
  String text;
  Uint8List? audioBytes;
  bool finishConversation;

  AudioMessage({
    required this.id,
    required this.user,
    required this.text,
    this.audioBytes,
    this.finishConversation = false,
  });
}
