import 'dart:async';
import 'dart:typed_data';

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

  final List<BookType> _userQuestionTypes = BookType.values;
  Map<BookType, double> _userWeights = Map.fromEntries([
    MapEntry(BookType.procrastination, 0),
    MapEntry(BookType.selfCare, 0),
    MapEntry(BookType.anxiety, 0),
    MapEntry(BookType.burnout, 0),
    MapEntry(BookType.communicationProblems, 0),
    MapEntry(BookType.workLifeBalance, 0),
  ]);
  final Map<BookType, Map<BookType, double>> _userAdditions = Map.fromEntries([
    MapEntry(
      BookType.procrastination,
      Map.fromEntries([
        MapEntry(BookType.procrastination, 1),
        MapEntry(BookType.selfCare, 0.1),
        MapEntry(BookType.anxiety, -0.1),
        MapEntry(BookType.burnout, 0.5),
        MapEntry(BookType.communicationProblems, 0),
        MapEntry(BookType.workLifeBalance, 0.3),
      ]),
    ),
    MapEntry(
      BookType.selfCare,
      Map.fromEntries([
        MapEntry(BookType.procrastination, 0.1),
        MapEntry(BookType.selfCare, 1),
        MapEntry(BookType.anxiety, 0),
        MapEntry(BookType.burnout, 0.2),
        MapEntry(BookType.communicationProblems, 0),
        MapEntry(BookType.workLifeBalance, 0.1),
      ]),
    ),
    MapEntry(
      BookType.anxiety,
      Map.fromEntries([
        MapEntry(BookType.procrastination, 0),
        MapEntry(BookType.selfCare, 0),
        MapEntry(BookType.anxiety, 1),
        MapEntry(BookType.burnout, 0.2),
        MapEntry(BookType.communicationProblems, 0.2),
        MapEntry(BookType.workLifeBalance, 0.5),
      ]),
    ),
    MapEntry(
      BookType.burnout,
      Map.fromEntries([
        MapEntry(BookType.procrastination, 0),
        MapEntry(BookType.selfCare, 0),
        MapEntry(BookType.anxiety, 0.1),
        MapEntry(BookType.burnout, 1),
        MapEntry(BookType.communicationProblems, 0),
        MapEntry(BookType.workLifeBalance, 0.6),
      ]),
    ),
    MapEntry(
      BookType.communicationProblems,
      Map.fromEntries([
        MapEntry(BookType.procrastination, 0),
        MapEntry(BookType.selfCare, 0.2),
        MapEntry(BookType.anxiety, 0.2),
        MapEntry(BookType.burnout, 0.1),
        MapEntry(BookType.communicationProblems, 1),
        MapEntry(BookType.workLifeBalance, 0),
      ]),
    ),
    MapEntry(
      BookType.workLifeBalance,
      Map.fromEntries([
        MapEntry(BookType.procrastination, 0.1),
        MapEntry(BookType.selfCare, 0.3),
        MapEntry(BookType.anxiety, 0.1),
        MapEntry(BookType.burnout, 0.1),
        MapEntry(BookType.communicationProblems, 0.2),
        MapEntry(BookType.workLifeBalance, 1),
      ]),
    ),
  ]);

  var questionNumber = 0;
  bool isQuestioning = false;
  bool isWaitingForResponse = false;

  DialogueSummary summary = DialogueSummary();
  final List<AudioMessage> _messagesList = [];
  final _messagesStream = StreamController<AudioMessage>.broadcast();

  final DialogFlowService _dialogFlowService;

  // methods

  Stream<AudioMessage> get messagesStream => _messagesStream.stream;

  void sendMessage(String text) async {
    _addUserMessage(text, null);

    if (summary.isFinalReached) return;

    if (isQuestioning) {
      var answer = await _dialogFlowService.sendIntent(text);

      if (answer.isError) {
        // say that didn't get it
        _addAIMessage(answer.message, answer.audioBase64);
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
          _makeBookDecision();
          summary.isFinalReached = true;
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

    if (question.isError) {
      // if we have enums that dialogflow isn't aware of
      // this block of code could be removed if not needed
      _addAIMessage('Having some server issues... Sorry', question.audioBase64);
      await _dialogFlowService.sendIntent(text);
      questionNumber++;
      if (_userQuestionTypes.length >= questionNumber)
        isWaitingForResponse = false;
    } else {
      _addAIMessage(question.message, question.audioBase64);
    }
  }

  Future<List<AudioMessage>> getMessages() async {
    return _messagesList;
  }

  void resetService() {
    _userWeights = Map.fromEntries([
      MapEntry(BookType.procrastination, 0),
      MapEntry(BookType.selfCare, 0),
      MapEntry(BookType.anxiety, 0),
      MapEntry(BookType.burnout, 0),
      MapEntry(BookType.communicationProblems, 0),
      MapEntry(BookType.workLifeBalance, 0),
    ]);

    questionNumber = 0;
    isQuestioning = false;
    isWaitingForResponse = false;

    summary = DialogueSummary();
  }

  // private

  void _makeBookDecision() {
    summary.bookType = _userWeights.entries
        .reduce((currentUser, nextUser) =>
            currentUser.value > nextUser.value ? currentUser : nextUser)
        .key;
  }

  void _processAnswer(ChatResponse answer) {
    if (answer.parameters.isNotEmpty) {
      var agreeParam = answer.parameters['questionResult'];

      if (agreeParam == 'true') {
        var type = _userQuestionTypes[questionNumber];
        _userAdditions[type]?.entries.forEach((element) {
          _userWeights[element.key] =
              (_userWeights[element.key] ?? 0) + element.value;
        });
      }

      isWaitingForResponse = false;
    }
    summary.overallSentiment += answer.sentiment;

    if (answer.isFinal) {
      summary.isFinalReached = true;
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

  void _addUserMessage(String message, Uint8List? audioMessage) {
    _addMessage(message, audioMessage, myUser);
  }

  void _addAIMessage(String message, Uint8List? audioMessage) {
    _addMessage(message, audioMessage, aiUser);
  }

  void _addMessage(String message, Uint8List? audioMessage, User user) {
    var object = AudioMessage(
      id: _messagesList.length.toString(),
      user: user,
      text: message,
      audioBytes: audioMessage,
      finishConversation: summary.isFinalReached,
    );
    _messagesList.add(object);
    _messagesStream.add(object);
  }
}
