import 'dart:async';
import 'dart:typed_data';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:tau_sound/tau_sound.dart';

class AudioService {
  final List<Uint8List> _queue = [];

  bool _isPlaying = false;

  AudioService() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      // if (controller?.playing ?? true) {
      //   _playSound();
      // }
    });
  }

  void addInQueue(Uint8List audioBytes) {
    _queue.add(audioBytes);
  }

  void _playSound() async {
    if (_queue.isEmpty) return;

    final sound = _queue.first;
    _queue.removeAt(0);

    
    // _player.lo
    // _player.play(whenFinished: () => print('finished'));

    // final audio = Audio.loadFromByteData(
    //   sound.buffer.asByteData(),
    //   onComplete: () {
    //     _isPlaying = false;
    //     if (_queue.isNotEmpty) _playSound();
    //   },
    // );

    // audio.play();
  }
}
