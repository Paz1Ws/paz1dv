import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/config.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/features/education/education_providers.dart';
import 'package:paz1dv/features/education/widgets/education_content.dart';
import 'package:paz1dv/core/providers/data_providers.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  late PageController _topController;
  late PageController _bottomController;
  late Timer _syncTimer;

  @override
  void initState() {
    super.initState();
    _topController = PageController(viewportFraction: 0.8, initialPage: 1000);
    _bottomController = PageController(
      viewportFraction: 0.8,
      initialPage: 1000,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSynchronizedAutoScroll();
    });
  }

  void _startSynchronizedAutoScroll() {
    _syncTimer = Timer.periodic(const Duration(milliseconds: 1800), (timer) {
      if (!mounted) return;

      final currentTopPage = ref.read(topCarouselPageProvider);
      final currentBottomPage = ref.read(bottomCarouselPageProvider);

      final nextTopPage = currentTopPage + 1;
      final nextBottomPage = currentBottomPage - 1;

      ref.read(topCarouselPageProvider.notifier).state = nextTopPage;
      ref.read(bottomCarouselPageProvider.notifier).state = nextBottomPage;

      // Only animate if controller is attached to a PageView
      if (_topController.hasClients) {
        _topController.animateToPage(
          nextTopPage,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOutCubic,
        );
      }
      if (_bottomController.hasClients) {
        _bottomController.animateToPage(
          nextBottomPage,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _syncTimer.cancel();
    _topController.dispose();
    _bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    final localizations = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    // Use the provider to fetch education data
    final educationAsync = ref.watch(educationProvider(locale));

    return Container(
      color: AppPalette.adaptiveColor(context),
      child: educationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (skillsData) => Column(
          mainAxisSize: MainAxisSize.min,
          spacing: kSpacing20,
          children: [
            isNarrow
                ? CarouselLayout(
                    size: size,
                    topController: _topController,
                    bottomController: _bottomController,
                    skillsData: skillsData,
                  )
                : GridLayout(size: size, skillsData: skillsData),

            Row(
              children: [
                const Spacer(flex: 1),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 6,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Text(
                          localizations.aboutEducation,
                          style: AppTypography.bodySmallBold(context).copyWith(
                            color: AppPalette.charcoalGray,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpacing20),
          ],
        ),
      ),
    );
  }
}
