import 'package:audioplayers/audioplayers.dart';

class BackgroundMusicService {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  Future<void> startBackgroundMusic() async {
    if (_isPlaying) return; // Already playing

    try {
      final source = AssetSource('sounds/background-music.mp3');
      await _player.setSource(source);
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.resume();
      _isPlaying = true;
    } catch (e) {
      print("Error starting music: $e");
      throw e; // Rethrow if you want to handle it outside
    }
  }

  void stopBackgroundMusic() {
    _player.stop(); 
    _isPlaying = false;
  }

  void pauseBackgroundMusic() {
    _player.pause();
    _isPlaying = false;
  }

  void resumeBackgroundMusic() {
    _player.resume(); // Resume playing
  }
}