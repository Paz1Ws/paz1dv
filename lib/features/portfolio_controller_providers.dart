import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PortfolioSection { profile, about, education, experience, skills, contact }

final scrollTargetProvider = StateProvider<PortfolioSection?>((ref) => null);

// Nuevo provider para controlar el scroll por índice
final scrollToIndexProvider = StateProvider<int?>((ref) => null);

// Mapeo de secciones a índices
const Map<PortfolioSection, int> sectionToIndexMap = {
  PortfolioSection.profile: 0,
  PortfolioSection.about: 1,
  PortfolioSection.education: 2,
  PortfolioSection.experience: 3,
  PortfolioSection.skills: 4,
  PortfolioSection.contact: 6, // 5 es el divider, 6 es el ContactScreen
};
