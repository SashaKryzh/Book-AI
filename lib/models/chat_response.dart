class ChatResponse {
  String message;
  Map<String, dynamic> parameters;
  double sentiment;
  bool isFinal;
  bool isError;
  // add intent type

  ChatResponse(
      {required this.message,
      required this.parameters,
      this.sentiment = 0.5,
      this.isFinal = false,
      this.isError = false});
}
