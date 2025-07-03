import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  AudioPlayer? _player;
  String? _currentBand;
  int _currentTrackIndex = 0;

  String? get currentBand => _currentBand;
  int get currentTrackIndex => _currentTrackIndex;

  // Determinar a qué banda pertenece una URL de audio
  String? getBandFromUrl(String url) {
    if (url.contains('beatles')) return 'The Beatles';
    if (url.contains('sinatra')) return 'Frank Sinatra';
    if (url.contains('lalaland')) return 'La La Land';
    return null;
  }

  // Obtener las canciones para una banda específica
  List<String> getSongsForBand(List<String> allSongs, String band) {
    final String searchTerm;

    if (band == 'The Beatles') {
      searchTerm = 'beatles';
    } else if (band == 'Frank Sinatra')
      searchTerm = 'sinatra';
    else if (band == 'La La Land')
      searchTerm = 'lalaland';
    else
      return [];

    return allSongs.where((song) => song.contains(searchTerm)).toList();
  }

  // Reproducir una canción
  Future<void> play(String url, String band) async {
    try {
      // Si ya hay un player, detenerlo
      if (_player != null) {
        await _player!.stop();
        _player!.dispose();
      }

      // Crear nuevo player
      _player = AudioPlayer();
      _player!.setReleaseMode(ReleaseMode.stop);

      await _player!.setSourceUrl(url);
      await _player!.resume();

      _currentBand = band;
      _currentTrackIndex = 0;
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  // Alternar entre dos canciones de la misma banda
  Future<void> toggleTrack(List<String> allSongs) async {
    if (_currentBand == null || _player == null) return;

    final songs = getSongsForBand(allSongs, _currentBand!);
    if (songs.length < 2) return;

    try {
      // Detener el player actual
      await _player!.stop();

      // Cambiar al siguiente track
      _currentTrackIndex = (_currentTrackIndex + 1) % songs.length;

      // Reproducir la nueva canción
      await _player!.setSourceUrl(songs[_currentTrackIndex]);
      await _player!.resume();

      print(
        'Cambiando a: ${songs[_currentTrackIndex]} (track $_currentTrackIndex)',
      );
    } catch (e) {
      print('Error toggling track: $e');
    }
  }

  // Detener la reproducción
  Future<void> stop() async {
    if (_player != null) {
      await _player!.stop();
    }
  }

  // Liberar recursos
  Future<void> dispose() async {
    if (_player != null) {
      await _player!.dispose();
      _player = null;
    }
  }
}

final audioPlayerProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(() async {
    await service.dispose();
  });
  return service;
});

final currentSongProvider = StateProvider<String?>((ref) => null);
final isPlayingProvider = StateProvider<bool>((ref) => false);
