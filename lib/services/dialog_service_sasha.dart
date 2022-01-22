import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:int20h_app/services/dialogflow_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

@lazySingleton
class DialogService {
  DialogService(this._dialogFlowService);

  final DialogFlowService _dialogFlowService;

  final _messagesStream = StreamController<Message>.broadcast();

  Stream<Message> get messagesStream => _messagesStream.stream;

  void sendMessage(String text) async {
    // after answear add new message to _messagesStream and save somewhere (list, database...) to later return in getMessages
  }

  Future<List<Message>> getMessages() async {
    return [];
  }
}
