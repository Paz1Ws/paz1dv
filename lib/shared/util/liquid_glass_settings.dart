import 'dart:math';
import 'dart:ui';

class LiquidGlassSettings {
  final Color glassColor;
  final double thickness;
  final double blur;
  final double chromaticAberration;
  final double blend;
  final double lightAngle;
  final double lightIntensity;
  final double ambientStrength;
  final double refractiveIndex;

  const LiquidGlassSettings({
    this.glassColor = const Color.fromARGB(0, 255, 255, 255),
    this.thickness = 20,
    this.blur = 0,
    this.chromaticAberration = .01,
    this.blend = 20,
    this.lightAngle = 0.5 * pi,
    this.lightIntensity = 1,
    this.ambientStrength = .01,
    this.refractiveIndex = 1.51,
  });

  LiquidGlassSettings copyWith({
    Color? glassColor,
    double? thickness,
    double? blur,
    double? chromaticAberration,
    double? blend,
    double? lightAngle,
    double? lightIntensity,
    double? ambientStrength,
    double? refractiveIndex,
  }) => LiquidGlassSettings(
    glassColor: glassColor ?? this.glassColor,
    thickness: thickness ?? this.thickness,
    blur: blur ?? this.blur,
    chromaticAberration: chromaticAberration ?? this.chromaticAberration,
    blend: blend ?? this.blend,
    lightAngle: lightAngle ?? this.lightAngle,
    lightIntensity: lightIntensity ?? this.lightIntensity,
    ambientStrength: ambientStrength ?? this.ambientStrength,
    refractiveIndex: refractiveIndex ?? this.refractiveIndex,
  );
}
