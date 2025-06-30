import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PortfolioSection {
  about,
  education,
  experience,
  skills,
  contact,
}

final scrollTargetProvider = StateProvider<PortfolioSection?>((ref) => null);
