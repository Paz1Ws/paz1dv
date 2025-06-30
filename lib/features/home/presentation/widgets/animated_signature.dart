import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/config.dart';
import 'package:paz1dv/shared/util/highlighted_signature_painter.dart';

// Animation state provider
final _animationStateProvider =
    StateNotifierProvider<AnimationStateNotifier, AnimationState>(
      (ref) => AnimationStateNotifier(),
    );

class AnimationState {
  final double pathProgress;
  final double brightness;
  final double signatureFade;
  final double dotHighlight;
  final double dotRotation;

  const AnimationState({
    required this.pathProgress,
    required this.brightness,
    required this.signatureFade,
    required this.dotHighlight,
    required this.dotRotation,
  });

  AnimationState copyWith({
    double? pathProgress,
    double? brightness,
    double? signatureFade,
    double? dotHighlight,
    double? dotRotation,
  }) {
    return AnimationState(
      pathProgress: pathProgress ?? this.pathProgress,
      brightness: brightness ?? this.brightness,
      signatureFade: signatureFade ?? this.signatureFade,
      dotHighlight: dotHighlight ?? this.dotHighlight,
      dotRotation: dotRotation ?? this.dotRotation,
    );
  }
}

class AnimationStateNotifier extends StateNotifier<AnimationState> {
  AnimationStateNotifier()
    : super(
        const AnimationState(
          pathProgress: 0.0,
          brightness: 0.0,
          signatureFade: 1.0,
          dotHighlight: 0.0,
          dotRotation: 0.0,
        ),
      );

  void updateAnimationValues({
    required double pathProgress,
    required double brightness,
    required double signatureFade,
    required double dotHighlight,
    required double dotRotation,
  }) {
    state = state.copyWith(
      pathProgress: pathProgress,
      brightness: brightness,
      signatureFade: signatureFade,
      dotHighlight: dotHighlight,
      dotRotation: dotRotation,
    );
  }
}

class AnimatedSignature extends ConsumerStatefulWidget {
  final double width;
  final double height;

  const AnimatedSignature({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  ConsumerState<AnimatedSignature> createState() => _AnimatedSignatureState();
}

class _AnimatedSignatureState extends ConsumerState<AnimatedSignature>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pathAnimation;
  late Animation<double> _brightnessAnimation;
  late Animation<double> _dotHighlightAnimation;
  late Animation<double> _dotRotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.repeat();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 10), // Longer for smoother transitions
      vsync: this,
    );

    // Path animation: forward -> pause -> reverse -> pause
    _pathAnimation = TweenSequence<double>([
      // Forward line-through (0 to 1)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      // Longer pause at end for highlight sequence
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 20),
      // Reverse (1 to 0) - highlighter disappears in reverse
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      // Brief pause before restart
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 15),
    ]).animate(_animationController);

    // Brightness for highlighter effect - smooth transition at end
    _brightnessAnimation = TweenSequence<double>([
      // Active during forward animation
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      // Smooth highlight sequence during pause
      TweenSequenceItem(
        tween: TweenSequence<double>([
          // Gentle increase when reaching end
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.0,
              end: 1.8,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 40,
          ),
          // Hold enhanced brightness
          TweenSequenceItem(tween: ConstantTween<double>(1.8), weight: 30),
          // Gentle decrease before reverse
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.8,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 30,
          ),
        ]),
        weight: 20,
      ),
      // Active during reverse animation
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.5,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      // Off during pause
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 15),
    ]).animate(_animationController);

    // Dot highlight animation - updated for double blink
    _dotHighlightAnimation = TweenSequence<double>([
      // No highlight during forward animation
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 35),
      // Sequential highlight during pause
      TweenSequenceItem(
        tween: TweenSequence<double>([
          // Wait for signature to highlight first
          TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10),
          // Blink 1: In
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 15,
          ),
          // Blink 1: Out
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.0,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 15,
          ),
          // Pause
          TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 5),
          // Blink 2: In
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 15,
          ),
          // Blink 2: Out
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.0,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 15,
          ),
          // Remainder of pause
          TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 25),
        ]),
        weight: 20,
      ),
      // No highlight during reverse and pause
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 45),
    ]).animate(_animationController);

    _dotRotationAnimation = TweenSequence<double>([
      // No rotation
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 35),
      // Rotation during pause
      TweenSequenceItem(
        tween: TweenSequence([
          TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10),
          // Spin during blinks
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.0,
              end: 0.05,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 65,
          ),
          // Reset
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.05,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 25,
          ),
        ]),
        weight: 20,
      ),
      // No rotation
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 45),
    ]).animate(_animationController);

    // Add listener to update Riverpod state
    _animationController.addListener(() {
      ref
          .read(_animationStateProvider.notifier)
          .updateAnimationValues(
            pathProgress: _pathAnimation.value,
            brightness: _brightnessAnimation.value,
            signatureFade: 1.0,
            dotHighlight: _dotHighlightAnimation.value,
            dotRotation: _dotRotationAnimation.value,
          );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animationState = ref.watch(_animationStateProvider);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: HighlightedSignaturePainter(
          animationState.pathProgress,
          animationState.brightness,
          animationState.signatureFade,
          animationState.dotHighlight,
          animationState.dotRotation,
          AppPalette.primaryColor(context),
        ),
      ),
    );
  }
}
