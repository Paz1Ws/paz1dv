import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:paz1dv/core/services/audio_player_service.dart';

class MusicFlyers extends ConsumerStatefulWidget {
  final double iconSize;

  const MusicFlyers({super.key, required this.iconSize});

  @override
  ConsumerState<MusicFlyers> createState() => _MusicFlyersState();
}

class _MusicFlyersState extends ConsumerState<MusicFlyers> {
  String? _currentlyPlayingBand;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final profileAsync = ref.watch(profileProvider(locale));
    final audioPlayerService = ref.read(audioPlayerProvider);

    return profileAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (profile) {
        if (profile.favoriteMusic.isEmpty ||
            profile.favoriteMusicLogos.isEmpty) {
          return const SizedBox.shrink();
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Flyer 1 - Arriba derecha
            Positioned(
              left: widget.iconSize * 0.5,
              top: -widget.iconSize * 0.1,
              child: _buildFlyer(0, profile, audioPlayerService),
            ),
            // Flyer 2 - Derecha
            Positioned(
              left: widget.iconSize * 1.3,
              top: -widget.iconSize * 0.3,
              child: _buildFlyer(1, profile, audioPlayerService),
            ),
            // Flyer 3 - Abajo derecha
            Positioned(
              left: widget.iconSize * 0.9,
              top: widget.iconSize * 0.5,
              child: _buildFlyer(2, profile, audioPlayerService),
            ),
            // Indicador de reproducción
            if (_currentlyPlayingBand != null)
              Positioned(
                top: widget.iconSize * 2,
                left: -widget.iconSize,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.skip_next,
                        size: 16,
                        color: AppPalette.darkMode,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Escuchando $_currentlyPlayingBand',
                        style: TextStyle(
                          color: AppPalette.darkMode,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFlyer(int index, profile, audioPlayerService) {
    final bandNames = ['The Beatles', 'Frank Sinatra', 'La La Land'];
    final band = bandNames[index];

    return GestureDetector(
      onTap: () async {
        final songs = audioPlayerService.getSongsForBand(
          profile.favoriteMusic,
          band,
        );
        if (songs.isNotEmpty) {
          await audioPlayerService.play(songs.first, band);
          setState(() => _currentlyPlayingBand = band);
        }
      },
      child: Container(
        width: widget.iconSize * 0.8,
        height: widget.iconSize * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(1, 1),
            ),
          ],
          border: Border.all(
            color: _currentlyPlayingBand == band
                ? AppPalette.primaryColor(context)
                : Colors.white,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            profile.favoriteMusicLogos[index],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(Icons.music_note),
          ),
        ),
      ),
    );
  }
}
