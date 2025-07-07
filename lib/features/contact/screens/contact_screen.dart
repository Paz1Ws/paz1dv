import 'dart:math';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/features/about/widgets/about_text_content.dart';
import 'package:paz1dv/features/contact/widgets/contact_widgets.dart';

final selectedKanjiProvider = StateProvider<String?>((ref) => null);
final showBenefitsProvider = StateProvider<bool>((ref) => false);

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final localizations = AppLocalizations.of(context)!;
    return SizedBox(
      height: isNarrow ? null : size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!isNarrow)
            _JapaneseBackgroundAnimation(controller: _animationController),
          if (isNarrow)
            Column(
              spacing: size.height * 0.02,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isNarrow) _MobileCurvedKanjiRow(size: size),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpacing12),
                  child: const ContactForm(),
                ),
                SocialMediaButtons(size: size),
                Text(
                  localizations.madeBy,
                  style: AppTypography.caption(context),
                ),
                SizedBox(height: size.height * 0.01),
              ],
            ),
          if (!isNarrow)
            SingleChildScrollView(
              child: Column(
                spacing: size.height * 0.02,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isNarrow) _MobileCurvedKanjiRow(size: size),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kSpacing12),
                    child: const ContactForm(),
                  ),
                  SocialMediaButtons(size: size),

                  Text(
                    localizations.madeBy,
                    style: AppTypography.caption(context),
                  ),
                  SizedBox(height: size.height * 0.01),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _JapaneseBackgroundAnimation extends ConsumerStatefulWidget {
  final AnimationController controller;

  const _JapaneseBackgroundAnimation({required this.controller});

  @override
  ConsumerState<_JapaneseBackgroundAnimation> createState() =>
      _JapaneseBackgroundAnimationState();
}

class _JapaneseBackgroundAnimationState
    extends ConsumerState<_JapaneseBackgroundAnimation> {
  bool _isAnyKanjiHovered = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final selectedKanji = ref.watch(selectedKanjiProvider);

    final animation = _isAnyKanjiHovered
        ? AlwaysStoppedAnimation(widget.controller.value)
        : CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut);

    return Stack(
      children: [
        // Left column - positioned relative to center
        Positioned(
          left: size.width * 0.1,
          top: size.height * 0.08,
          child: Column(
            spacing: size.height * 0.15,
            children: [
              // 知 (Chi) - Knowledge
              Jello(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(seconds: 2),
                infinite: true,
                child: _AnimatedKanji(
                  kanji: '知',
                  animation: animation,
                  startOffset: const Offset(0, 0),
                  endOffset: const Offset(20, 15),
                  startAngle: -0.05,
                  endAngle: 0.05,
                  size: size.width * 0.08,
                  isSelected: selectedKanji == '知',
                  onHoverChanged: (isHovered) {
                    setState(() => _isAnyKanjiHovered = isHovered);
                    if (isHovered) {
                      ref.read(selectedKanjiProvider.notifier).state = '知';
                      ref.read(showBenefitsProvider.notifier).state = false;
                    } else if (!isHovered && selectedKanji == '知') {
                      ref.read(selectedKanjiProvider.notifier).state = null;
                    }
                  },
                ),
              ),

              // 忍 (Nin) - Patience
              Swing(
                delay: const Duration(milliseconds: 1000),
                duration: const Duration(seconds: 5),
                infinite: true,
                child: _AnimatedKanji(
                  kanji: '忍',
                  animation: animation,
                  startOffset: const Offset(0, 0),
                  endOffset: const Offset(-15, 20),
                  startAngle: -0.03,
                  endAngle: 0.03,
                  size: size.width * 0.08,
                  isSelected: selectedKanji == '忍',
                  onHoverChanged: (isHovered) {
                    setState(() => _isAnyKanjiHovered = isHovered);
                    if (isHovered) {
                      ref.read(selectedKanjiProvider.notifier).state = '忍';
                      ref.read(showBenefitsProvider.notifier).state = false;
                    } else if (!isHovered && selectedKanji == '忍') {
                      ref.read(selectedKanjiProvider.notifier).state = null;
                    }
                  },
                ),
              ),

              // 志 (Shi) - Will
              Flash(
                delay: const Duration(milliseconds: 50),
                duration: const Duration(seconds: 5),
                infinite: true,
                child: _AnimatedKanji(
                  kanji: '志',
                  animation: animation,
                  startOffset: const Offset(0, 0),
                  endOffset: const Offset(25, -10),
                  startAngle: -0.04,
                  endAngle: 0.04,
                  size: size.width * 0.08,
                  isSelected: selectedKanji == '志',
                  onHoverChanged: (isHovered) {
                    setState(() => _isAnyKanjiHovered = isHovered);
                    if (isHovered) {
                      ref.read(selectedKanjiProvider.notifier).state = '志';
                      ref.read(showBenefitsProvider.notifier).state = false;
                    } else if (!isHovered && selectedKanji == '志') {
                      ref.read(selectedKanjiProvider.notifier).state = null;
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // Right column - positioned relative to center
        Positioned(
          right: size.width * 0.1,
          top: size.height * 0.08,
          child: Column(
            spacing: size.height * 0.15,
            children: [
              // 美 (Bi) - Beauty
              Flash(
                delay: const Duration(milliseconds: 50),
                duration: const Duration(seconds: 5),
                infinite: true,
                child: _AnimatedKanji(
                  kanji: '美',
                  animation: animation,
                  startOffset: const Offset(0, 0),
                  endOffset: const Offset(-20, 15),
                  startAngle: 0.05,
                  endAngle: -0.05,
                  size: size.width * 0.08,
                  isSelected: selectedKanji == '美',
                  onHoverChanged: (isHovered) {
                    setState(() => _isAnyKanjiHovered = isHovered);
                    if (isHovered) {
                      ref.read(selectedKanjiProvider.notifier).state = '美';
                      ref.read(showBenefitsProvider.notifier).state = false;
                    } else if (!isHovered && selectedKanji == '美') {
                      ref.read(selectedKanjiProvider.notifier).state = null;
                    }
                  },
                ),
              ),

              // 誠 (Sei) - Sincerity
              Jello(
                delay: const Duration(milliseconds: 1250),
                duration: const Duration(seconds: 2),
                infinite: true,
                child: _AnimatedKanji(
                  kanji: '誠',
                  animation: animation,
                  startOffset: const Offset(0, 0),
                  endOffset: const Offset(15, -20),
                  startAngle: 0.03,
                  endAngle: -0.03,
                  size: size.width * 0.08,
                  isSelected: selectedKanji == '誠',
                  onHoverChanged: (isHovered) {
                    setState(() => _isAnyKanjiHovered = isHovered);
                    if (isHovered) {
                      ref.read(selectedKanjiProvider.notifier).state = '誠';
                      ref.read(showBenefitsProvider.notifier).state = false;
                    } else if (!isHovered && selectedKanji == '誠') {
                      ref.read(selectedKanjiProvider.notifier).state = null;
                    }
                  },
                ),
              ),

              // 永 (Ei) - Eternity
              Swing(
                delay: const Duration(milliseconds: 1000),
                duration: const Duration(seconds: 5),
                infinite: true,
                child: _AnimatedKanji(
                  kanji: '永',
                  animation: animation,
                  startOffset: const Offset(0, 0),
                  endOffset: const Offset(-25, 10),
                  startAngle: 0.04,
                  endAngle: -0.04,
                  size: size.width * 0.08,
                  isSelected: selectedKanji == '永',
                  onHoverChanged: (isHovered) {
                    setState(() => _isAnyKanjiHovered = isHovered);
                    if (isHovered) {
                      ref.read(selectedKanjiProvider.notifier).state = '永';
                      ref.read(showBenefitsProvider.notifier).state = true;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileCurvedKanjiRow extends ConsumerStatefulWidget {
  final Size size;

  const _MobileCurvedKanjiRow({required this.size});

  @override
  ConsumerState<_MobileCurvedKanjiRow> createState() =>
      _MobileCurvedKanjiRowState();
}

class _MobileCurvedKanjiRowState extends ConsumerState<_MobileCurvedKanjiRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedKanji = ref.watch(selectedKanjiProvider);
    final kanjiData = [
      {'kanji': '知', 'delay': 0},
      {'kanji': '美', 'delay': 200},
      {'kanji': '忍', 'delay': 400},
      {'kanji': '誠', 'delay': 600},
      {'kanji': '志', 'delay': 800},
      {'kanji': '永', 'delay': 1000},
    ];

    return SizedBox(
      height: widget.size.height * 0.12,
      width: widget.size.width * 0.9,
      child: CustomPaint(
        painter: _CurvedPathPainter(),
        child: Stack(
          children: kanjiData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final kanji = data['kanji'] as String;
            final delay = data['delay'] as int;

            // Calculate position along the same curved path as _CurvedPathPainter
            final progress = index / (kanjiData.length - 1);
            final width = widget.size.width * 0.8;
            final height = widget.size.height * 0.08;

            // Use cubic bezier curve calculation (same as _CurvedPathPainter)
            final startY = height * 0.6;
            final controlY = height * 0.2;
            final endY = height * 0.6;

            // Cubic bezier interpolation
            final t = progress;
            final oneMinusT = 1 - t;
            final xPos = width * t;
            final yPos =
                oneMinusT * oneMinusT * startY +
                2 * oneMinusT * t * controlY +
                t * t * endY;

            return Positioned(
              left: xPos,
              top: yPos - widget.size.height * 0.03,
              child: _MobileAnimatedKanji(
                kanji: kanji,
                animationController: _animationController,
                delay: delay,
                size: widget.size.width * 0.08,
                isSelected: selectedKanji == kanji,
                onTap: () {
                  if (selectedKanji == kanji) {
                    // Deselecting current kanji
                    ref.read(selectedKanjiProvider.notifier).state = null;
                    if (kanji == '永') {
                      ref.read(showBenefitsProvider.notifier).state = false;
                    }
                  } else {
                    // Selecting new kanji
                    ref.read(selectedKanjiProvider.notifier).state = kanji;

                    if (kanji == '永') {
                      // Show benefits for eternity kanji
                      ref.read(showBenefitsProvider.notifier).state = true;
                    } else {
                      // Hide benefits for non-eternity kanjis
                      ref.read(showBenefitsProvider.notifier).state = false;
                    }
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CurvedPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Optional: Draw a subtle curved path line for visual guidance
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.6);

    final controlPoint1 = Offset(size.width * 0.25, size.height * 0.2);
    final controlPoint2 = Offset(size.width * 0.75, size.height * 0.2);
    final endPoint = Offset(size.width, size.height * 0.6);

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MobileAnimatedKanji extends StatefulWidget {
  final String kanji;
  final AnimationController animationController;
  final int delay;
  final double size;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobileAnimatedKanji({
    required this.kanji,
    required this.animationController,
    required this.delay,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_MobileAnimatedKanji> createState() => _MobileAnimatedKanjiState();
}

class _MobileAnimatedKanjiState extends State<_MobileAnimatedKanji> {
  final bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        // Add slight floating animation with delay
        final floatOffset = (widget.delay / 1000) * 2 * 3.14159;
        final floatY =
            sin(widget.animationController.value * 2 * 3.14159 + floatOffset) *
            3;

        return Transform.translate(
          offset: Offset(0, floatY),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()
                ..scale(widget.isSelected || _isHovered ? 1.3 : 1.0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: widget.isSelected || _isHovered ? 0.9 : 0.4,
                child: Text(
                  widget.kanji,
                  style: GoogleFonts.notoSansJp(
                    fontSize: widget.size,
                    color: widget.isSelected || _isHovered
                        ? AppPalette.primaryColor(context)
                        : AppPalette.reverseAdaptiveColor(context),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedKanji extends StatefulWidget {
  final String kanji;
  final Animation<double> animation;
  final Offset startOffset;
  final Offset endOffset;
  final double startAngle;
  final double endAngle;
  final double size;
  final bool isSelected;
  final ValueChanged<bool> onHoverChanged;

  const _AnimatedKanji({
    required this.kanji,
    required this.animation,
    required this.startOffset,
    required this.endOffset,
    required this.startAngle,
    required this.endAngle,
    required this.size,
    required this.isSelected,
    required this.onHoverChanged,
  });

  @override
  State<_AnimatedKanji> createState() => _AnimatedKanjiState();
}

class _AnimatedKanjiState extends State<_AnimatedKanji> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        final angle = lerpDouble(
          widget.startAngle,
          widget.endAngle,
          widget.animation.value,
        )!;

        return Transform.rotate(
          angle: angle,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              widget.onHoverChanged(true);
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              widget.onHoverChanged(false);
            },
            child: GestureDetector(
              onTap: () {
                widget.onHoverChanged(!widget.isSelected);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()
                  ..scale(widget.isSelected || _isHovered ? 1.2 : 1.0),
                child: AnimatedOpacity(
                  duration: const Duration(
                    milliseconds: 500,
                  ), // Smoother transitions
                  opacity: widget.isSelected || _isHovered
                      ? 0.9
                      : 0.3, // More visible when not hovered
                  child: Text(
                    widget.kanji,
                    style: GoogleFonts.notoSansJp(
                      fontSize: widget.size,
                      color: widget.isSelected || _isHovered
                          ? AppPalette.primaryColor(context)
                          : AppPalette.reverseAdaptiveColor(
                              context,
                            ), // More visible color
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
