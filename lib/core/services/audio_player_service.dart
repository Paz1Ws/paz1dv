import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:paz1dv/config/config.dart';

class AudioPlayerService {
  AudioPlayer? _player;
  String? _currentBand;
  int _currentTrackIndex = 0;

  String? get currentBand => _currentBand;
  int get currentTrackIndex => _currentTrackIndex;

  // Get a song name from URL (extract from path)
  String getSongNameFromUrl(String url) {
    // Extract file name from URL
    final fileName = url.split('/').last;
    debugPrint('Extracted fileName: $fileName');

    // Remove extension
    final nameWithoutExt = fileName.split('.').first;
    debugPrint('Name without extension: $nameWithoutExt');

    // URL decode to handle %20 (spaces) and other encoded characters
    String cleanName = Uri.decodeComponent(nameWithoutExt);
    debugPrint('After URL decoding: $cleanName');

    // Remove album identifier (everything after the last dash that contains album name)
    // For "City Of Stars-lalaland" -> remove "-lalaland"
    // For "Fly me To The Moon-sinatra" -> remove "-sinatra"
    final albumPatterns = ['lalaland', 'sinatra', 'beatles'];
    for (final pattern in albumPatterns) {
      final albumRemovalPattern = RegExp('-$pattern\$', caseSensitive: false);
      cleanName = cleanName.replaceAll(albumRemovalPattern, '');
    }
    debugPrint('After removing album identifier: $cleanName');

    // Remove any remaining numbers with dashes (like -123, -2, etc.)
    final dashNumPattern = RegExp(r'-\d+$');
    cleanName = cleanName.replaceAll(dashNumPattern, '');
    debugPrint('After removing trailing numbers: $cleanName');

    // Clean up any remaining underscores or hyphens and trim
    cleanName = cleanName.replaceAll('_', ' ').replaceAll('-', ' ').trim();
    debugPrint('After replacing _ and - with spaces: $cleanName');

    // Convert to title case
    final result = cleanName
        .split(' ')
        .where((word) => word.isNotEmpty) // Remove empty strings
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
    debugPrint('Final song name: $result');
    return result;
  }

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
    } catch (e) {
      print('Error toggling track: $e');
    }
  }

  // Play specific track by index
  Future<void> playTrackByIndex(
    List<String> allSongs,
    String band,
    int index,
  ) async {
    if (band != _currentBand || _player == null) {
      // Different band or no player yet
      _currentBand = band;
    }

    final songs = getSongsForBand(allSongs, band);
    if (songs.isEmpty) return;

    _currentTrackIndex = index % songs.length;

    try {
      // Si ya hay un player, detenerlo
      if (_player != null) {
        await _player!.stop();
      } else {
        _player = AudioPlayer();
      }

      _player!.setReleaseMode(ReleaseMode.stop);
      await _player!.setSourceUrl(songs[_currentTrackIndex]);
      await _player!.resume();
    } catch (e) {
      print('Error playing track by index: $e');
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

// Audio player state management
class AudioState {
  final String? currentBand;
  final int currentSongIndex;
  final bool isPlaying;
  final bool isLoading;

  AudioState({
    this.currentBand,
    this.currentSongIndex = 0,
    this.isPlaying = false,
    this.isLoading = false,
  });

  AudioState copyWith({
    String? currentBand,
    int? currentSongIndex,
    bool? isPlaying,
    bool? isLoading,
  }) {
    return AudioState(
      currentBand: currentBand ?? this.currentBand,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AudioStateNotifier extends StateNotifier<AudioState> {
  final AudioPlayerService _service;

  AudioStateNotifier(this._service) : super(AudioState());

  Future<void> playSong(
    List<String> allSongs,
    String band, {
    int? index,
  }) async {
    state = state.copyWith(isLoading: true);

    final songs = _service.getSongsForBand(allSongs, band);
    if (songs.isEmpty) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final songIndex =
        index ??
        ((state.currentBand == band)
            ? (state.currentSongIndex + 1) % songs.length
            : 0);

    await _service.playTrackByIndex(allSongs, band, songIndex);

    state = AudioState(
      currentBand: band,
      currentSongIndex: songIndex,
      isPlaying: true,
      isLoading: false,
    );
  }

  void stopPlaying() {
    _service.stop();
    state = state.copyWith(isPlaying: false);
  }
}

final audioPlayerProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(() async {
    await service.dispose();
  });
  return service;
});

final audioStateProvider =
    StateNotifierProvider<AudioStateNotifier, AudioState>((ref) {
      final service = ref.watch(audioPlayerProvider);
      return AudioStateNotifier(service);
    });
