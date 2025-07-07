import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/app/app_icons.dart';
import 'package:paz1dv/config/config.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:paz1dv/core/services/audio_player_service.dart';
import 'package:paz1dv/features/home/presentation/widgets/action_buttons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:paz1dv/features/home/presentation/widgets/music_flyer_item.dart';

final showMusicFlyersProvider = StateProvider<bool>((ref) => false);
final hoveredFlyerProvider = StateProvider<int?>((ref) => null);

class MusicFlyers extends ConsumerWidget {
  final double iconSize;
  final bool isNarrow;

  const MusicFlyers({super.key, required this.iconSize, this.isNarrow = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    final profileAsync = ref.watch(profileProvider(locale));
    final showFlyers = ref.watch(remixButtonTappedProvider);

    if (!showFlyers && !isNarrow) {
      return const SizedBox.shrink();
    }

    return profileAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (profile) {
        if (profile.favoriteMusic.isEmpty ||
            profile.favoriteMusicLogos.isEmpty) {
          return const SizedBox.shrink();
        }

        final bandNames = ['The Beatles', 'Frank Sinatra', 'La La Land'];

        if (isNarrow) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: MusicFlyerItem(
                  index: index,
                  iconSize: iconSize,
                  band: bandNames[index],
                  logoUrl: profile.favoriteMusicLogos[index],
                  songs: profile.favoriteMusic,
                ),
              );
            }),
          );
        }

        return SizedBox(
          width: iconSize * 2.5,
          height: iconSize * 2.5,
          child: Stack(
            children: [
              Positioned(
                left: iconSize * 0.6,
                top: iconSize * 0.4,

                child: MusicFlyerItem(
                  index: 1,
                  iconSize: iconSize,
                  band: bandNames[1],
                  logoUrl: profile.favoriteMusicLogos[1],
                  songs: profile.favoriteMusic,
                ),
              ),
              // Flyer 1 - Arriba, parcialmente oculto
              Positioned(
                left: iconSize * 0.8,
                top: iconSize * 1.2,
                child: MusicFlyerItem(
                  index: 0,
                  iconSize: iconSize,
                  band: bandNames[0],
                  logoUrl: profile.favoriteMusicLogos[0],
                  songs: profile.favoriteMusic,
                ),
              ),
              // Flyer 2 - Izquierda, parcialmente oculto

              // Flyer 3 - Derecha, parcialmente oculto
              Positioned(
                left: iconSize * 1.5,
                top: iconSize * 0.8,
                child: MusicFlyerItem(
                  index: 2,
                  iconSize: iconSize,
                  band: bandNames[2],
                  logoUrl: profile.favoriteMusicLogos[2],
                  songs: profile.favoriteMusic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
