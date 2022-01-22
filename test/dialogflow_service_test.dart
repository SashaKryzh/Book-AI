import 'package:flutter_test/flutter_test.dart';
// import 'package:injectable/injectable.dart';
import 'package:int20h_app/core/injection/injection.dart';
import 'package:int20h_app/services/dialogflow_service.dart';
import 'package:int20h_app/services/dialogue_service.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  test('About', () async {
    var dialog = getIt<DialogFlowService>();
    print("Start------");

    var smth = await dialog.sendIntent("Привет");
    print("End------");
    expect(smth, "Answer");
  });
}
