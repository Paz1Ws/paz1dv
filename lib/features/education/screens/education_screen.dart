import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/config.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/features/education/education_providers.dart';
import 'package:paz1dv/features/education/widgets/education_content.dart';
import 'package:paz1dv/core/providers/data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  late PageController _topController;
  late PageController _bottomController;
  Timer? _syncTimer;

  final _educationSectionKey = GlobalKey();
  final bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _topController = PageController(viewportFraction: 0.8, initialPage: 1000);
    _bottomController = PageController(
      viewportFraction: 0.8,
      initialPage: 1000,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && ResponsiveConstants.isNarrowScreen(context)) {
        _startSynchronizedAutoScroll();
      }
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
    _syncTimer?.cancel();
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
      key: _educationSectionKey,
      color: AppPalette.adaptiveColor(context),
      child: educationAsync.when(
        loading: () => _EducationSkeleton(size: size, isNarrow: isNarrow),
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
                    animate: _hasAnimated,
                  )
                : GridLayout(
                    size: size,
                    skillsData: skillsData,
                    animate: _hasAnimated,
                  ),
            _hasAnimated
                ? FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 500),
                    child: EducationFooterText(localizations: localizations),
                  )
                : EducationFooterText(localizations: localizations),
            const SizedBox(height: kSpacing20),
          ],
        ),
      ),
    );
  }
}

class EducationFooterText extends StatelessWidget {
  final AppLocalizations localizations;

  const EducationFooterText({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _EducationSkeleton extends StatelessWidget {
  final Size size;
  final bool isNarrow;

  const _EducationSkeleton({required this.size, required this.isNarrow});

  @override
  Widget build(BuildContext context) {
    final boneColor = AppPalette.adaptiveColor(
      context,
      light: AppPalette.lightGray,
      dark: AppPalette.darkCharcoal,
    );

    return Skeletonizer.zone(
      effect: ShimmerEffect(
        baseColor: boneColor,
        highlightColor: boneColor.withAlpha(128),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: kSpacing20,
        children: [
          if (isNarrow)
            Column(
              spacing: kSpacing20,
              children: [
                _CarouselRowSkeleton(size: size),
                _CarouselRowSkeleton(size: size),
              ],
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: kSpacing20,
                mainAxisSpacing: kSpacing20,
                childAspectRatio: 3.0,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => _EducationCardSkeleton(size: size),
            ),
          Row(
            children: [
              const Spacer(flex: 1),
              Flexible(
                fit: FlexFit.tight,
                flex: 6,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Bone.multiText(
                    lines: 3,
                    width: size.width * 0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing20),
        ],
      ),
    );
  }
}

class _CarouselRowSkeleton extends StatelessWidget {
  final Size size;
  const _CarouselRowSkeleton({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpacing8),
          child: _EducationCardSkeleton(size: size),
        ),
      ),
    );
  }
}

class _EducationCardSkeleton extends StatelessWidget {
  final Size size;
  const _EducationCardSkeleton({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.7,
      padding: const EdgeInsets.all(kPadding16),
      decoration: BoxDecoration(
        color: AppPalette.lightGray.withAlpha(30),
        borderRadius: BorderRadius.circular(kRadius12),
      ),
      child: Row(
        spacing: kSpacing12,
        children: [
          Bone.circle(size: size.width * 0.08),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: kSpacing8,
              children: [
                Bone.text(width: size.width * 0.3),
                Bone.multiText(lines: 2, width: size.width * 0.25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
