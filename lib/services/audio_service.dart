import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class AudioService {
  Future<void> playMessageSound() async {
    var pool = Soundpool.fromOptions();

    var soundId = await rootBundle
        .load('sounds/elegant-notification-sound.mp3')
        .then((ByteData soundData) {
      return pool.loadAndPlay(soundData);
    });
    // var streamId = await pool.play(soundId);
  }
}
