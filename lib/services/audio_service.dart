import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class AudioService {
  final soundpool = Soundpool.fromOptions();

  void playMessageSound() async {
    final soundId = await rootBundle
        .load('assets/sounds/elegant-notification-sound.mp3')
        .then((ByteData soundData) {
      return soundpool.load(soundData);
    });

    await soundpool.play(soundId);
  }
}
