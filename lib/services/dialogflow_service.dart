import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:injectable/injectable.dart';

@singleton
class DialogFlowService {
  final DialogFlowtter _dialogFlow;

  DialogFlowService._(DialogFlowtter service) : _dialogFlow = service;

  @factoryMethod
  static Future<DialogFlowService> create() async {
    final service = await DialogFlowtter.fromFile();

    return DialogFlowService._(service);
  }

  Future<String> sendIntent(String message) async {
    var response = await _dialogFlow.detectIntent(
      queryInput: QueryInput(
        text: TextInput(text: message, languageCode: 'ru'),
      ),
    );

    if (response.message == null) return 'Error connecting to di  alogflow';

    print('Here is our intent: ' + message);
    print(response.toString());

    return response.message.toString();
  }
}
