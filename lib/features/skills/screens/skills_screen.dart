import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:paz1dv/features/skills/domain/skill_model.dart';
import 'package:paz1dv/core/services/paz1dv_http_requests.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  int _hoveredIndex = -1;

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
      child: skillsAsync.when(
        loading: () => Skeletonizer(
          child: _SkillsContent(
            skills: List.generate(8, (_) => SkillModel.fake()),
            ordered: true,
          ),
        ),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (skills) {
          if (skills.isEmpty) {
            return Center(child: Text('No skills found'));
          }

          final iconSize = size.height * 0.1;

          if (!isNarrow) {
            _initMotions(skills, size.width, size.height * 0.4, iconSize);
          }

          return _SkillsContent(
            skills: skills,
            ordered: _ordered || isNarrow,
            motions: _motions,
            controller: _controller,
            hoveredIndex: _hoveredIndex,
            onHover: (index) => setState(() => _hoveredIndex = index),
            onToggleOrder: (ordered) => setState(() => _ordered = ordered),
          );
        },
      ),
    );
  }
}

class _SkillsContent extends StatelessWidget {
  final List<SkillModel> skills;
  final bool ordered;
  final List<_SkillMotion>? motions;
  final AnimationController? controller;
  final int? hoveredIndex;
  final Function(int)? onHover;
  final Function(bool)? onToggleOrder;

  const _SkillsContent({
    required this.skills,
    required this.ordered,
    this.motions,
    this.controller,
    this.hoveredIndex,
    this.onHover,
    this.onToggleOrder,
  });

  Widget _buildSkillIcon(
    BuildContext context,
    SkillModel skill,
    double iconSize,
    int index,
  ) {
    final isHovered = hoveredIndex == index;
    return MouseRegion(
      onEnter: (_) => onHover?.call(index),
      onExit: (_) => onHover?.call(-1),
      child: SizedBox(
        width: iconSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: kSpacing12,
          children: [
            controller != null
                ? AnimatedBuilder(
                    animation: controller!,
                    builder: (context, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(iconSize / 3),
                          boxShadow: isHovered
                              ? [
                                  BoxShadow(
                                    color: AppPalette.primaryColor(
                                      context,
                                    ).withAlpha(90),
                                    blurRadius: 36,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(controller!.value * 2 * pi),
                          child: child,
                        ),
                      );
                    },
                    child: _buildSkillImage(skill, iconSize),
                  )
                : _buildSkillImage(skill, iconSize),
            Text(
              skill.name,
              textAlign: TextAlign.center,
              style: AppTypography.subtitleSmall(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillImage(SkillModel skill, double iconSize) {
    return Skeleton.replace(
      width: iconSize,
      height: iconSize,
      child: skill.logoUrl != null && skill.logoUrl!.isNotEmpty
          ? Image.network(
              skill.logoUrl!,
              width: iconSize,
              height: iconSize,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: kIconSize48),
            )
          : const Icon(Icons.extension, size: kIconSize48),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final size = MediaQuery.sizeOf(context);
    final iconSize = size.height * 0.1;

    if (ordered) {
      return Center(
        child: Wrap(
          spacing: kSpacing20,
          runSpacing: kSpacing20,
          alignment: WrapAlignment.center,
          children: skills.asMap().entries.map((entry) {
            return _buildSkillIcon(context, entry.value, iconSize, entry.key);
          }).toList(),
        ),
      );
    } else {
      return MouseRegion(
        onEnter: (_) => onToggleOrder?.call(true),
        onExit: (_) => onToggleOrder?.call(false),
        child: SizedBox(
          width: size.width,
          height: size.height * 0.4,
          child: Stack(
            children: [
              for (int i = 0; i < skills.length; i++)
                AnimatedBuilder(
                  animation: controller!,
                  builder: (context, child) {
                    final t = ((controller!.value + motions![i].delay) % 1.0);
                    final curvedT = 0.5 - 0.5 * cos(t * 2 * pi);
                    final pos = Offset(
                      lerpDouble(
                        motions![i].start.dx,
                        motions![i].end.dx,
                        curvedT,
                      )!,
                      lerpDouble(
                        motions![i].start.dy,
                        motions![i].end.dy,
                        curvedT,
                      )!,
                    );
                    return Positioned(
                      left: pos.dx.clamp(0, size.width - iconSize),
                      top: pos.dy.clamp(
                        0,
                        (size.height * 0.4) - iconSize - kSpacing20,
                      ),
                      child: _buildSkillIcon(context, skills[i], iconSize, i),
                    );
                  },
                ),
            ],
          ),
        ),
      );
    }
  }
}
