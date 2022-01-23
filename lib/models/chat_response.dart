class ChatResponse {
  String message;
  String? audioBase64;
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
