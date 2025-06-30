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

class ExperienceDetailView extends ConsumerWidget {
  final ExperienceModel item;
  final VoidCallback onBack;

  const ExperienceDetailView({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    // Watch for locale changes to rebuild when language changes
    ref.watch(languageProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.title,
              style: AppTypography.heading3(
                context,
                color: AppPalette.reverseAdaptiveColor(context),
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
        ),
        const SizedBox(height: kSpacing30),
        Flex(
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
                  const SizedBox(height: kSpacing20),
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
            if (!isNarrow) const SizedBox(width: kSpacing50),
            if (isNarrow) const SizedBox(height: kSpacing30),
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
        ),
        const SizedBox(height: kSpacing30),
        // Replace the single image container with a carousel
        if (item.carouselImages.isNotEmpty) ...[
          SizedBox(
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kRadius12),
              child: CarouselView(
                itemExtent: 350,
                shrinkExtent: 200,
                children: item.carouselImages.map((imageUrl) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: kSpacing8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kRadius12),
                      color: AppPalette.darkCharcoal,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kRadius12),
                      child: Image.network(
                        imageUrl,
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
                }).toList(),
              ),
            ),
          ),
        ] else ...[
          // Fallback to background image if no carousel images
          Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadius12),
              image: DecorationImage(
                image: NetworkImage(item.backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kRadius12),
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
