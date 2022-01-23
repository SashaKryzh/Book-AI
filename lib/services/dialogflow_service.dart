import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:injectable/injectable.dart';
import 'package:int20h_app/models/book_types.dart';
import 'package:int20h_app/models/chat_response.dart';

@lazySingleton
class DialogFlowService {
  DialogFlowtter? _dialogFlow;

  Future<DialogFlowtter> get _dialogFlowInstance async {
    _dialogFlow ??= await DialogFlowtter.fromFile();

    return _dialogFlow!;
  }

  Future<ChatResponse> sendIntent(String userMessage) async {
    final response = await (await _dialogFlowInstance).detectIntent(
      queryInput: QueryInput(
        text: TextInput(text: userMessage, languageCode: 'en'),
      ),
      audioConfig: OutputAudioConfig(
        audioEncoding: OutputAudioEncoding.OUTPUT_AUDIO_ENCODING_MP3,
      ),
    );

    var textResponse = response.text ?? 'Error';
    if (response.message == null) {
      return ChatResponse(
        message: textResponse,
        parameters: Map.identity(),
        isError: true,
      );
    }

    var parameters = response.queryResult?.parameters ?? Map.identity();
    var sentiment = response.queryResult?.sentimentAnalysisResult
            ?.queryTextSentiment?.magnitude ??
        0;
    var isEnd =
        response.queryResult?.diagnosticInfo?['end_conversation'] ?? false;

    var isError = response.queryResult?.action == 'input.unknown';
    var audioBase64 = response.outputAudio;

    return ChatResponse(
      message: textResponse,
      parameters: parameters,
      sentiment: sentiment,
      audioBase64: audioBase64,
      isFinal: isEnd,
      isError: isError,
    );
  }

  Future<ChatResponse> triggerBookIntent(BookType bookType) async {
    final response = await (await _dialogFlowInstance).detectIntent(
      queryInput: QueryInput(
        text: TextInput(text: bookType.name, languageCode: 'en'),
      ),
      audioConfig: OutputAudioConfig(
          audioEncoding: OutputAudioEncoding.OUTPUT_AUDIO_ENCODING_MP3),
    );

    var textResponse = response.text ?? 'Error';
    if (response.message == null) {
      return ChatResponse(
        message: textResponse,
        parameters: Map.identity(),
        isError: true,
      );
    }

    var audioBase64 = response.outputAudio;

    return ChatResponse(
      message: textResponse,
      parameters: Map.identity(),
      audioBase64: audioBase64,
    );
  }
}
