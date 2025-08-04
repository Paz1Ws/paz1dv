import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_config_providers.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/config/l10n/l10n.dart';
import 'package:paz1dv/features/portfolio_controller_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Paz1Dv Studio',
      home: ResponsiveBreakpoints.builder(
        child: const PortfolioHomeScreen(),
        breakpoints: ResponsiveConstants.breakpoints,
      ),
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: locale,
      theme: AppPalette.themeData(ThemeMode.light),
      darkTheme: AppPalette.themeData(ThemeMode.dark),
      themeMode: themeMode,
    );
  }
}
