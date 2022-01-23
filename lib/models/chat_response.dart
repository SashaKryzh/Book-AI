import 'dart:typed_data';

class ChatResponse {
  String message;
  Uint8List? audioBase64;
  Map<String, dynamic> parameters;
  double sentiment;
  bool isFinal;
  bool isError;

  ChatResponse({
    required this.message,
    required this.parameters,
    this.audioBase64,
    this.sentiment = 0,
    this.isFinal = false,
    this.isError = false,
  });
}
