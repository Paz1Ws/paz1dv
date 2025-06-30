// Providers for carousel state
import 'package:flutter_riverpod/flutter_riverpod.dart';

final topCarouselPageProvider = StateProvider<int>((ref) => 1000);
final bottomCarouselPageProvider = StateProvider<int>((ref) => 1000);
