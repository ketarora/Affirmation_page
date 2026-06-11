import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  static final AudioPlayerService instance = AudioPlayerService._internal();
  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  final ValueNotifier<int> currentTrackIndex = ValueNotifier(-1);
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);
  final ValueNotifier<Duration> currentPosition = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> totalDuration = ValueNotifier(Duration.zero);

  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _stateSub;

  final List<String> _filenames = [
    '432hz_healing.mp3',
    'morning_abundance.mp3',
    'inner_peace_rain.mp3',
    'deep_sleep_delta.mp3',
    'study_focus_beta.mp3',
    'manifest_while_sleep.mp3',
    'chakra_balancing.mp3',
    'self_love_morning.mp3',
  ];

  Future<void> initialize() async {
    _posSub = _player.positionStream.listen((pos) {
      currentPosition.value = pos;
    });
    _durSub = _player.durationStream.listen((dur) {
      totalDuration.value = dur ?? Duration.zero;
    });
    _stateSub = _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing && state.processingState != ProcessingState.completed;
      if (state.processingState == ProcessingState.completed) {
         _player.seek(Duration.zero);
         _player.pause();
      }
    });
  }

  Future<void> playTrack(int index) async {
    if (index < 0 || index >= _filenames.length) return;

    String fileToPlay = _filenames[index];
    if (index == 1) fileToPlay = '528hz_miracle.mp3';
    if (index == 2) fileToPlay = '639hz_connection.mp3';
    if (index == 3) fileToPlay = '174hz_sleep.mp3';
    if (index == 4) fileToPlay = '741hz_throat.mp3';
    if (index == 5) fileToPlay = '852hz_intuition.mp3';
    if (index == 6) fileToPlay = '963hz_crown.mp3';
    if (index == 7) fileToPlay = '396hz_fear.mp3';

    try {
      if (currentTrackIndex.value != index) {
        await _player.setAsset('assets/audio/$fileToPlay');
        currentTrackIndex.value = index;
      }
      await _player.play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    currentTrackIndex.value = -1;
    currentPosition.value = Duration.zero;
  }

  void seekPercent(double percent) {
    final total = totalDuration.value;
    if (total > Duration.zero) {
      final ms = (total.inMilliseconds * percent).round();
      _player.seek(Duration(milliseconds: ms));
    }
  }

  String formatDuration(Duration d) {
    final mins = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
  }
}
