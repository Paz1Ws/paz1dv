import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_config_providers.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/features/experience/domain/experience_model.dart';
import 'package:paz1dv/features/experience/widgets/detail_item.dart';
import 'package:paz1dv/shared/util/text_parser.dart';
import 'dart:async';

class ExperienceDetailView extends ConsumerWidget {
  final ExperienceModel item;
  final VoidCallback onBack;
  final bool animate;

  const ExperienceDetailView({
    super.key,
    required this.item,
    required this.onBack,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    ref.watch(languageProvider);

    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: kSpacing30,
      children: [
        animate
            ? FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: _Header(item: item, onBack: onBack, isNarrow: isNarrow),
              )
            : _Header(item: item, onBack: onBack, isNarrow: isNarrow),

        animate
            ? FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 200),
                child: _Content(item: item, isNarrow: isNarrow),
              )
            : _Content(item: item, isNarrow: isNarrow),

        animate
            ? FadeIn(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 400),
                child: _ImageCarousel(item: item),
              )
            : _ImageCarousel(item: item),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ExperienceModel item;
  final VoidCallback onBack;
  final bool isNarrow;

  const _Header({
    required this.item,
    required this.onBack,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            item.title,
            style: AppTypography.heading3(
              context,
              color: AppPalette.reverseAdaptiveColor(context),
            ),
            maxLines: 3,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: AppPalette.reverseAdaptiveColor(context),
          ),
          onPressed: onBack,
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final ExperienceModel item;
  final bool isNarrow;

  const _Content({
    required this.item,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Flex(
      direction: isNarrow ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: isNarrow ? 0 : 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DetailItem(
                      title: 'Industry',
                      value: item.industry,
                    ),
                  ),
                  Expanded(
                    child: DetailItem(title: 'Client', value: item.client),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: DetailItem(
                      title: 'Service',
                      value: item.service,
                    ),
                  ),
                  Expanded(
                    child: DetailItem(
                      title: 'Date',
                      value: item.formattedDateRange(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isNarrow) SizedBox(width: size.width * 0.04),
        if (isNarrow) SizedBox(height: size.height * 0.03),
        Flexible(
          flex: isNarrow ? 0 : 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: TextParser.parseDescriptionWithBullets(
              context,
              item.description,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final ExperienceModel item;
  const _ImageCarousel({required this.item});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.item.carouselImages.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (!mounted) return;
        final nextPage = (_currentPage + 1) % widget.item.carouselImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final images = widget.item.carouselImages;
    final hasImages = images.isNotEmpty;

    final carouselHeight = size.height * 0.4;
    final carouselWidth = size.width * 0.6;

    if (hasImages) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: carouselHeight,
            width: carouselWidth,
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kRadius12),
                    color: AppPalette.darkCharcoal,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kRadius12),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppPalette.darkCharcoal,
                            borderRadius: BorderRadius.circular(kRadius12),
                          ),
                          child: Center(
                            child: Text(
                              'Image not available',
                              style: AppTypography.bodySmall(
                                context,
                                color: AppPalette.lightMode,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.004),
                width: isActive ? size.width * 0.025 : size.width * 0.012,
                height: size.height * 0.012,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppPalette.primaryColor(context)
                      : AppPalette.mutedGray,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
        ],
      );
    } else {
      // Fallback to background image if no carousel images
      return Container(
        height: carouselHeight,
        width: carouselWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kRadius12),
          image: DecorationImage(
            image: NetworkImage(widget.item.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadius12),
            color: AppPalette.darkMode.withAlpha(51),
          ),
        ),
      );
    }
  }
}
