import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:paz1dv/features/skills/domain/skill_model.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';

class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key});

  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillMotion {
  final Offset start;
  final Offset end;
  final double delay;
  _SkillMotion({required this.start, required this.end, required this.delay});
}

class _SkillsScreenState extends ConsumerState<SkillsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_SkillMotion> _motions;
  bool _ordered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    _motions = [];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initMotions(
    List<SkillModel> skills,
    double width,
    double height,
    double iconSize,
  ) {
    if (_motions.length == skills.length) return;
    final rand = Random();
    _motions = List.generate(skills.length, (i) {
      final startX = rand.nextDouble() * (width - iconSize);
      final startY = rand.nextDouble() * (height - iconSize - kSpacing20);
      final endX = rand.nextDouble() * (width - iconSize);
      final endY = rand.nextDouble() * (height - iconSize - kSpacing20);
      final delay = rand.nextDouble();
      return _SkillMotion(
        start: Offset(startX, startY),
        end: Offset(endX, endY),
        delay: delay,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final skillsAsync = ref.watch(skillsProvider);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      width: double.infinity,
      // Remove fixed height for narrow screens to make it flexible
      height: isNarrow ? null : size.height * 0.4,
      child: skillsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (skills) {
          if (skills.isEmpty) {
            return Center(child: Text('No skills found'));
          }

          final iconSize = isNarrow ? size.width * 0.15 : size.width * 0.06;

          if (!isNarrow) {
            _initMotions(skills, size.width, size.height * 0.4, iconSize);
          }

          if (isNarrow) {
            // For narrow screens, use intrinsic height with flexible layout
            return IntrinsicHeight(
              child: Center(
                child: Wrap(
                  spacing: kSpacing20,
                  runSpacing: kSpacing20,
                  alignment: WrapAlignment.center,
                  children: skills.map((skill) {
                    return SizedBox(
                      width: iconSize,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: kSpacing12,
                        children: [
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return PhysicalModel(
                                color: Colors.transparent,
                                shadowColor: AppPalette.primaryColor(
                                  context,
                                ).withAlpha(180),
                                borderRadius: BorderRadius.circular(
                                  iconSize / 2,
                                ),
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(_controller.value * 2 * pi),
                                  child:
                                      skill.logoUrl != null &&
                                          skill.logoUrl!.isNotEmpty
                                      ? Image.network(
                                          skill.logoUrl!,
                                          width: iconSize,
                                          height: iconSize,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: kIconSize48,
                                                  ),
                                        )
                                      : const Icon(
                                          Icons.extension,
                                          size: kIconSize48,
                                        ),
                                ),
                              );
                            },
                          ),
                          Text(
                            skill.name,
                            textAlign: TextAlign.center,
                            style: AppTypography.subtitleSmall(context),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          } else {
            // Desktop: Use Center widget to automatically center content
            return MouseRegion(
              onEnter: (_) => setState(() => _ordered = true),
              onExit: (_) => setState(() => _ordered = false),
              child: Center(
                child: SizedBox(
                  width: size.width,
                  height: size.height * 0.4,
                  child: Stack(
                    children: [
                      if (_ordered)
                        // When ordered, use Wrap for automatic centered layout
                        Center(
                          child: Wrap(
                            spacing: kSpacing20,
                            runSpacing: kSpacing20,
                            alignment: WrapAlignment.center,
                            children: skills.map((skill) {
                              return SizedBox(
                                width: iconSize,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: kSpacing12,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        return PhysicalModel(
                                          color: Colors.transparent,
                                          shadowColor: AppPalette.primaryColor(
                                            context,
                                          ).withAlpha(180),
                                          borderRadius: BorderRadius.circular(
                                            iconSize / 2,
                                          ),
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2, 0.001)
                                              ..rotateY(
                                                _controller.value * 2 * pi,
                                              ),
                                            child:
                                                skill.logoUrl != null &&
                                                    skill.logoUrl!.isNotEmpty
                                                ? Image.network(
                                                    skill.logoUrl!,
                                                    width: iconSize,
                                                    height: iconSize,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => const Icon(
                                                          Icons.broken_image,
                                                          size: kIconSize48,
                                                        ),
                                                  )
                                                : const Icon(
                                                    Icons.extension,
                                                    size: kIconSize48,
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                      skill.name,
                                      textAlign: TextAlign.center,
                                      style: AppTypography.subtitleSmall(
                                        context,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      else
                        // When not ordered, use random motion across full width
                        for (int i = 0; i < skills.length; i++)
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final t =
                                  ((_controller.value + _motions[i].delay) %
                                  1.0);
                              final curvedT = 0.5 - 0.5 * cos(t * 2 * pi);
                              final pos = Offset(
                                lerpDouble(
                                  _motions[i].start.dx,
                                  _motions[i].end.dx,
                                  curvedT,
                                )!,
                                lerpDouble(
                                  _motions[i].start.dy,
                                  _motions[i].end.dy,
                                  curvedT,
                                )!,
                              );
                              return Positioned(
                                left: pos.dx.clamp(0, size.width - iconSize),
                                top: pos.dy.clamp(
                                  0,
                                  (size.height * 0.4) - iconSize - kSpacing20,
                                ),
                                child: SizedBox(
                                  width: iconSize,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: kSpacing12,
                                    children: [
                                      AnimatedBuilder(
                                        animation: _controller,
                                        builder: (context, child) {
                                          return PhysicalModel(
                                            color: Colors.transparent,
                                            shadowColor:
                                                AppPalette.primaryColor(
                                                  context,
                                                ).withAlpha(180),
                                            borderRadius: BorderRadius.circular(
                                              iconSize / 2,
                                            ),
                                            child: Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.identity()
                                                ..setEntry(3, 2, 0.001)
                                                ..rotateY(
                                                  _controller.value * 2 * pi,
                                                ),
                                              child:
                                                  skills[i].logoUrl != null &&
                                                      skills[i]
                                                          .logoUrl!
                                                          .isNotEmpty
                                                  ? Image.network(
                                                      skills[i].logoUrl!,
                                                      width: iconSize,
                                                      height: iconSize,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) => const Icon(
                                                            Icons.broken_image,
                                                            size: kIconSize48,
                                                          ),
                                                    )
                                                  : const Icon(
                                                      Icons.extension,
                                                      size: kIconSize48,
                                                    ),
                                            ),
                                          );
                                        },
                                      ),
                                      Text(
                                        skills[i].name,
                                        textAlign: TextAlign.center,
                                        style: AppTypography.subtitleSmall(
                                          context,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
