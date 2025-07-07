import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_icons.dart';
import 'package:paz1dv/core/services/audio_player_service.dart';
import 'package:paz1dv/features/home/presentation/widgets/music_flyers.dart';

/// A clickable music flyer item that plays songs when tapped.
/// Extracted to a separate widget for better separation of concerns.
class MusicFlyerItem extends ConsumerWidget {
  final int index;
  final double iconSize;
  final String band;
  final String logoUrl;
  final List<String> songs;

  const MusicFlyerItem({
    super.key,
    required this.index,
    required this.iconSize,
    required this.band,
    required this.logoUrl,
    required this.songs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioStateProvider);
    final isCurrentlyPlaying = audioState.currentBand == band;
    final hoveredFlyer = ref.watch(hoveredFlyerProvider);
    final isHovered = hoveredFlyer == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => ref.read(hoveredFlyerProvider.notifier).state = index,
      onExit: (_) => ref.read(hoveredFlyerProvider.notifier).state = null,
      child: GestureDetector(
        onTap: () {
          ref
              .read(audioStateProvider.notifier)
              .playSong(
                songs,
                band,
                index: isCurrentlyPlaying
                    ? (audioState.currentSongIndex + 1) % songs.length
                    : 0,
              );
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: isHovered ? 1.05 : 1.0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: iconSize,
              height: iconSize * 1.2,
              decoration: BoxDecoration(
                color: AppPalette.lightMode,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.darkMode.withAlpha(66),
                    blurRadius: 4,
                    offset: const Offset(1, 1),
                  ),
                ],
                border: Border.all(
                  color: isCurrentlyPlaying
                      ? AppPalette.primaryColor(context)
                      : AppPalette.lightMode,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(AppIcons.headphones, color: AppPalette.charcoalGray),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
