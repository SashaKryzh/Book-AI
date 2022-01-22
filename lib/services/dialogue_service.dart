import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:int20h_app/constants.dart';
import 'package:int20h_app/services/dialogflow_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

@lazySingleton
class DialogueService {
  DialogueService(this._dialogFlowService);

  final List<Message> _messagesList = [];
  final _messagesStream = StreamController<Message>.broadcast();

  final DialogFlowService _dialogFlowService;

  Stream<Message> get messagesStream => _messagesStream.stream;

  void sendMessage(String text) async {
    _addUserMessage(text);
    // await _dialogFlowService.;
    _addAIMessage("Answer");
  }

  Future<List<Message>> getMessages() async {
    return _messagesList;
  }

  void _addUserMessage(String message) {
    _addMessage(message, myUser);
  }

  void _addAIMessage(String message) {
    _addMessage(message, aiUser);
  }

  void _addMessage(String message, User user) {
    var object = TextMessage(
      author: user,
      id: _messagesList.length.toString(),
      text: message,
    );
    _messagesList.add(object);
    _messagesStream.add(object);
  }
}
