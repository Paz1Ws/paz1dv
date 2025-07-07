// Providers for carousel state
import 'package:flutter_riverpod/flutter_riverpod.dart';

final topCarouselPageProvider = StateProvider<int>((ref) => 1000);
final bottomCarouselPageProvider = StateProvider<int>((ref) => 1000);

// Provider to track if the education section animation has been played
final educationAnimationPlayedProvider = StateProvider<bool>((ref) => false);
