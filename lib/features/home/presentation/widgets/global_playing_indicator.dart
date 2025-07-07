import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/app/app_icons.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:paz1dv/core/services/audio_player_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GlobalPlayingIndicator extends ConsumerStatefulWidget {
  final Size size;

  const GlobalPlayingIndicator({super.key, required this.size});

  @override
  ConsumerState<GlobalPlayingIndicator> createState() =>
      _GlobalPlayingIndicatorState();
}

class _GlobalPlayingIndicatorState extends ConsumerState<GlobalPlayingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _nextButtonController;
  late Animation<double> _nextButtonRotation;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _nextButtonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _nextButtonRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _nextButtonController, curve: Curves.easeInOut),
    );

    _pulseController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..forward().then((_) {
            _pulseController.reverse();
          });
  }

  @override
  void dispose() {
    _nextButtonController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioStateProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final profileAsync = ref.watch(profileProvider(locale));
    final audioService = ref.read(audioPlayerProvider);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);

    return PlayerCard(
      isNarrow: isNarrow,
      size: widget.size,
      audioState: audioState,
      profileAsync: profileAsync,
      audioService: audioService,
      animation: _nextButtonRotation,
      pulseController: _pulseController,
      onNextButtonTap: () {
        _nextButtonController.forward().then((_) {
          _nextButtonController.reverse();
        });

        if (audioState.currentBand != null) {
          ref
              .read(audioStateProvider.notifier)
              .playSong(
                profileAsync.value?.favoriteMusic ?? [],
                audioState.currentBand!,
                index: (audioState.currentSongIndex + 1),
              );
        }
      },
    );
  }
}

class PlayerCard extends StatelessWidget {
  final Size size;
  final AudioState audioState;
  final AsyncValue profileAsync;
  final AudioPlayerService audioService;
  final Animation<double> animation;
  final VoidCallback onNextButtonTap;
  final AnimationController pulseController;
  final bool isNarrow;

  const PlayerCard({
    super.key,
    required this.size,
    required this.audioState,
    required this.profileAsync,
    required this.audioService,
    required this.animation,
    required this.onNextButtonTap,
    required this.pulseController,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Card(
      color: Colors.transparent,
      elevation: 12,
      shadowColor: AppPalette.darkMode.withAlpha(120),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius20),
      ),
      child: Container(
        width: size.width / 4,
        height: size.height / 8,
        padding: const EdgeInsets.symmetric(
          horizontal: kPadding16,
          vertical: kPadding8,
        ),
        decoration: BoxDecoration(
          color: AppPalette.adaptiveColor(context),
          borderRadius: BorderRadius.circular(kRadius20),
          border: Border.all(color: AppPalette.primaryColor(context), width: 2),
        ),
        child: profileAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (profile) {
            if (audioState.currentBand == null) return const SizedBox.shrink();

            return Row(
              spacing: kSpacing12,
              mainAxisSize: MainAxisSize.min,
              children: [
                BandIcon(
                  isNarrow: isNarrow,
                  audioState: audioState,
                  profile: profile,
                  size: screenSize,
                  pulseController: pulseController,
                ),

                Expanded(
                  child: SongInfo(
                    audioState: audioState,
                    audioService: audioService,
                    profile: profile,
                    localizations: AppLocalizations.of(context)!,
                  ),
                ),

                Row(
                  spacing: kSpacing4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Combined Play/Pause button
                    PlayPauseButton(
                      isPlaying: audioState.isPlaying,
                      size: screenSize,
                      isNarrow: isNarrow,
                    ),

                    // Next button
                    NextButton(
                      animation: animation,
                      onTap: onNextButtonTap,
                      size: screenSize,
                      isNarrow: isNarrow,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BandIcon extends ConsumerWidget {
  final AudioState audioState;
  final dynamic profile;
  final Size size;
  final AnimationController pulseController;
  final bool isNarrow;

  const BandIcon({
    super.key,
    required this.audioState,
    required this.profile,
    required this.size,
    required this.pulseController,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconSize = isNarrow ? size.width * 0.1 : size.width * 0.05;

    final iconWidget = ClipRRect(
      borderRadius: BorderRadius.circular(kRadius12),
      child: Image.network(
        _getBandLogo(profile.favoriteMusicLogos, audioState.currentBand),
        width: iconSize,
        height: iconSize,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          AppIcons.headphones,
          color: AppPalette.primaryColor(context),
          size: iconSize * 0.6,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + (pulseController.value * 0.1),
          child: child,
        );
      },
      child: isNarrow
          ? MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // Cycle through bands directly
                  final bandNames = [
                    'The Beatles',
                    'Frank Sinatra',
                    'La La Land',
                  ];
                  final currentBandIndex = bandNames.indexOf(
                    audioState.currentBand ?? '',
                  );
                  final nextBandIndex =
                      (currentBandIndex + 1) % bandNames.length;
                  final nextBand = bandNames[nextBandIndex];

                  // Play first song of the next band
                  ref
                      .read(audioStateProvider.notifier)
                      .playSong(profile.favoriteMusic, nextBand, index: 0);
                },
                child: iconWidget,
              ),
            )
          : iconWidget,
    );
  }

  String _getBandLogo(List<String> logos, String? bandName) {
    if (bandName == null || logos.isEmpty) return '';

    if (bandName.contains('Beatles')) {
      return logos[0];
    } else if (bandName.contains('Sinatra')) {
      return logos[1];
    } else if (bandName.contains('La La Land')) {
      return logos[2];
    }

    return logos.first;
  }
}

class SongInfo extends StatelessWidget {
  final AudioState audioState;
  final AudioPlayerService audioService;
  final dynamic profile;
  final AppLocalizations localizations;

  const SongInfo({
    super.key,
    required this.audioState,
    required this.audioService,
    required this.profile,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          audioState.currentBand ?? '',
          style: AppTypography.bodyMedium(
            context,
            color: AppPalette.primaryColor(context),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        Skeleton.replace(
          child: Text(
            _getCurrentSongName(),
            style: AppTypography.labelSmall(
              context,
              color: AppPalette.charcoalGray,
            ).copyWith(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getCurrentSongName() {
    if (audioState.currentBand == null) return '';

    final songs = audioService.getSongsForBand(
      profile.favoriteMusic,
      audioState.currentBand!,
    );
    if (songs.isEmpty) return '';

    final url = songs[audioState.currentSongIndex % songs.length];
    return audioService.getSongNameFromUrl(url);
  }
}

// Replace separate PauseButton with combined PlayPauseButton
class PlayPauseButton extends ConsumerWidget {
  final bool isPlaying;
  final Size size;
  final bool isNarrow;
  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.size,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonSize = isNarrow ? size.width * 0.08 : size.width * 0.03;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (isPlaying) {
            ref.read(audioPlayerProvider).stop();
            ref.read(audioStateProvider.notifier).stopPlaying();
          } else {
            final audioState = ref.read(audioStateProvider);
            if (audioState.currentBand != null) {
              final locale = Localizations.localeOf(context).languageCode;
              final profile = ref.read(profileProvider(locale)).valueOrNull;
              if (profile != null) {
                ref
                    .read(audioStateProvider.notifier)
                    .playSong(
                      profile.favoriteMusic,
                      audioState.currentBand!,
                      index: audioState.currentSongIndex,
                    );
              }
            }
          }
        },
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: isPlaying
                ? AppPalette.charcoalGray
                : AppPalette.primaryColor(context),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPlaying ? AppIcons.stop : AppIcons.play,
            size: buttonSize * 0.5,
            color: isPlaying ? AppPalette.lightMode : AppPalette.darkMode,
          ),
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onTap;
  final Size size;
  final bool isNarrow;
  const NextButton({
    super.key,
    required this.animation,
    required this.onTap,
    required this.size,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = isNarrow ? size.width * 0.08 : size.width * 0.03;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: animation.value * 2 * 3.14159,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  color: AppPalette.primaryColor(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.next,
                  size: buttonSize * 0.5,
                  color: AppPalette.darkMode,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
