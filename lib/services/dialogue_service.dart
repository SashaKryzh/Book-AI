import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:int20h_app/constants.dart';
import 'package:int20h_app/dto/audio_message.dart';
import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/models/chat_response.dart';
import 'package:int20h_app/models/dialogue_summary.dart';
import 'package:int20h_app/services/dialogflow_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

@lazySingleton
class DialogueService {
  DialogueService(this._dialogFlowService);

  List<BookType> _userQuestionTypes = BookType.values;
  Map<BookType, double> _userWeights = Map.fromEntries([
    MapEntry(BookType.procrastination, 0),
    MapEntry(BookType.selfCare, 0),
    // MapEntry(BookType.workLifeBalance, 0),
  ]);

  bool isQuestioning = false;
  bool isWaitingForResponse = false;

  var questionNumber = 0;

  final DialogueSummary _summary = DialogueSummary();
  final List<AudioMessage> _messagesList = [];
  final _messagesStream = StreamController<AudioMessage>.broadcast();

  final DialogFlowService _dialogFlowService;

  Stream<AudioMessage> get messagesStream => _messagesStream.stream;

  void sendMessage(String text) async {
    _addUserMessage(text, null);

    if (_summary.isFinalReached) return;

    if (isQuestioning) {
      var answer = await _dialogFlowService.sendIntent(text);

      if (answer.isError) {
        _addAIMessage(
            answer.message, answer.audioBase64); // say that didn't get it
        isWaitingForResponse = true;
      } else {
        _processAnswer(answer);

        if (!isWaitingForResponse) {
          questionNumber++;

          if (questionNumber == _userQuestionTypes.length) {
            isQuestioning = false;
            _addFinalAIMessage();
            return;
          }
        }
      }
    } else {
      if (_isEnoughDataAboutUser()) {
        var answer = await _dialogFlowService.sendIntent(text);
        _addAIMessage(answer.message, answer.audioBase64);
        if (answer.isFinal) {
          _summary.isFinalReached = true;
        }
        return;
      } else {
        isQuestioning = true;
        var answer = await _dialogFlowService.sendIntent(text);
        _addAIMessage(answer.message, answer.audioBase64);
      }
    }
    var question = await _dialogFlowService
        .triggerBookIntent(_userQuestionTypes[questionNumber]);
    _addAIMessage(question.message, question.audioBase64);
  }

  Future<List<AudioMessage>> getMessages() async {
    return _messagesList;
  }

  void _processAnswer(ChatResponse answer) {
    if (answer.parameters.isNotEmpty) {
      var agreeParam = answer.parameters['questionResult'];

      if (agreeParam == 'true') {
        var type = _userQuestionTypes[questionNumber];
        _userWeights[type] = (_userWeights[type] ?? 0) + 1;
      }

      isWaitingForResponse = false;
    }

    if (answer.isFinal) {
      _summary.isFinalReached = true;
    }
  }

  bool _isEnoughDataAboutUser() {
    return questionNumber == _userQuestionTypes.length;
  }

  void _addFinalAIMessage() {
    _addAIMessage("I've collected enough data.", null);
    _addAIMessage("You can say 'Finish' to get the result", null);
    _addAIMessage('Or continue with the small talk :)', null);
    _addMessage(_userWeights.toString(), null, aiUser);
  }

  void _addUserMessage(String message, String? audioMessage) {
    _addMessage(message, audioMessage, myUser);
  }

  void _addAIMessage(String message, String? audioMessage) {
    _addMessage(message, audioMessage, aiUser);
  }

  void _addMessage(String message, String? audioMessage, User user) {
    var object = AudioMessage(
        id: _messagesList.length.toString(),
        user: user,
        text: message,
        audioBase64: audioMessage);
    _messagesList.add(object);
    _messagesStream.add(object);
  }
}
