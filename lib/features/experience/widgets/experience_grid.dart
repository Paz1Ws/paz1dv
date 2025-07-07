import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/features/experience/domain/experience_model.dart';
import 'package:paz1dv/features/experience/screens/experience_screen.dart';
import 'package:paz1dv/features/experience/widgets/experience_card.dart';

class ExperienceGrid extends StatelessWidget {
  final List<ExperienceModel> experienceItems;
  final Size size;
  final bool animate;

  const ExperienceGrid({
    super.key,
    required this.experienceItems,
    required this.size,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isNarrow = ResponsiveConstants.isNarrowScreen(context);
        return Column(
          spacing: kSpacing20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isNarrow ? 1 : 2,
                crossAxisSpacing: kSpacing20,
                mainAxisSpacing: kSpacing20,
                childAspectRatio: isNarrow ? 1.5 : 1.2,
              ),
              itemCount: experienceItems.length,
              itemBuilder: (context, index) {
                final item = experienceItems[index];
                return animate
                    ? FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        delay: Duration(milliseconds: 200 * index),
                        child: ExperienceCard(
                          size: size,
                          item: item,
                          onTap: () =>
                              ref.read(selectedExperienceProvider.notifier).state =
                                  item,
                        ),
                      )
                    : ExperienceCard(
                        size: size,
                        item: item,
                        onTap: () =>
                            ref.read(selectedExperienceProvider.notifier).state =
                                item,
                      );
              },
            ),
          ],
        );
      },
    );
  }
}
