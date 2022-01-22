import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DialogFlowService {
  DialogFlowtter? _dialogFlow;

  Future<DialogFlowtter> get _dialogFlowInstance async {
    _dialogFlow ??= await DialogFlowtter.fromFile();

    return _dialogFlow!;
  }

  Future<String> sendIntent(String message) async {
    final response = await (await _dialogFlowInstance).detectIntent(
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
