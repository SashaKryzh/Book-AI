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

  Map<BookType, double> _userWeights = Map.fromEntries([
    MapEntry(BookType.burnout, 0),
    MapEntry(BookType.procrastination, 0),
    MapEntry(BookType.workLifeBalance, 0),
  ]);

  List<MapEntry<String, BookType>> _userQuestions = List.from([
    MapEntry("Do you feel like burnout?", BookType.burnout),
    MapEntry("Do you feel like procrastination?", BookType.procrastination),
    MapEntry("Do you feel like workLifeBalance?", BookType.workLifeBalance),
  ]);

  var questionNumber = 0;

  final DialogueSummary _summary = DialogueSummary();
  final List<Message> _messagesList = [];
  final _messagesStream = StreamController<Message>.broadcast();

  final DialogFlowService _dialogFlowService;

  Stream<Message> get messagesStream => _messagesStream.stream;

  void sendMessage(String text) async {
    _addUserMessage(text);

    if (questionNumber == _userQuestions.length || _summary.isFinalReached) {
      // find result
      _addFinalAIMessage();
      return;
    }

    ChatResponse answer = await _dialogFlowService.sendIntent(text, true);
    if (answer.isError) {
      _addAIMessage(answer.message);
      // ask question again
      _addAIMessage(_userQuestions[questionNumber].key);
    } else {
      _processAnswer(answer); // update weights here
      questionNumber++;
      _addAIMessage(answer.message);
    }
  }

  Future<List<Message>> getMessages() async {
    return _messagesList;
  }

  void _processAnswer(ChatResponse answer) {
    if (answer.parameters.isNotEmpty) {
      var agreeParam = answer.parameters['agree'] ?? false;

      if (agreeParam) {
        var type = _userQuestions[questionNumber].value;
        _userWeights[type] = (_userWeights[type] ?? 0) + 1;
      }
    }

    if (answer.isFinal) {
      _summary.isFinalReached = true;
    }
    // _addAIMessage("Your sentiment is " + answer.sentiment.toString());

    // todo get all the data about parameters, mood, sentiment...
  }

  bool _isEnoughDataAboutUser() {
    return _summary.isFinalReached &&
        _summary.moodType != MoodType.undefined &&
        _summary.bookType != BookType.undefined;
  }

  void _addUserMessage(String message) {
    _addMessage(message, myUser);
  }

  void _addAIMessage(String message) {
    _addMessage(message, aiUser);
  }

  void _addFinalAIMessage() {
    _addMessage("Я собрал достаточно параметров", aiUser);
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
