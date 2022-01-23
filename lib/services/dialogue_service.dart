import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:int20h_app/constants.dart';
import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/models/chat_response.dart';
import 'package:int20h_app/models/dialogue_summary.dart';
import 'package:int20h_app/models/mood_types.dart';
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
  final List<Message> _messagesList = [];
  final _messagesStream = StreamController<Message>.broadcast();

  final DialogFlowService _dialogFlowService;

  Stream<Message> get messagesStream => _messagesStream.stream;

  void sendMessage(String text) async {
    _addUserMessage(text);

    if (isQuestioning) {
      var answer = await _dialogFlowService.sendIntent(text);

      if (answer.isError) {
        _addAIMessage(answer.message); // say that didn't get it
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
        _addAIMessage(answer.message);
        return;
      } else {
        isQuestioning = true;
      }
    }
    var question = await _dialogFlowService
        .triggerBookIntent(_userQuestionTypes[questionNumber]);
    _addAIMessage(question.message);
  }

  Future<List<Message>> getMessages() async {
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
    _addAIMessage("I've collected enough data.");
    _addAIMessage("You can say 'Finish' to get the result");
    _addAIMessage('Or continue with the small talk :)');
    _addMessage(_userWeights.toString(), aiUser);
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
