import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/config.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/features/education/education_providers.dart';
import 'package:paz1dv/features/education/domain/models/education_model.dart';
import 'package:paz1dv/features/education/widgets/education_card.dart';

class GridLayout extends StatelessWidget {
  const GridLayout({super.key, required this.size, required this.skillsData});

  final Size size;
  final List<EducationModel> skillsData;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: kSpacing20,
        mainAxisSpacing: kSpacing20,
        childAspectRatio: 3.0,
      ),
      itemCount: skillsData.length,
      itemBuilder: (context, index) {
        final skill = skillsData[index];
        return EducationCard(
          size: size,
          title: skill.title,
          description: skill.description,
          imagePath: skill.imagePath,
          provider: skill.provider,
        );
      },
    );
  }
}

class CarouselLayout extends StatelessWidget {
  const CarouselLayout({
    super.key,
    required this.size,
    required this.topController,
    required this.bottomController,
    required this.skillsData,
  });

  final Size size;
  final PageController topController;
  final PageController bottomController;
  final List<EducationModel> skillsData;

  @override
  Widget build(BuildContext context) {
    // Alternating split: even indices for top, odd for bottom
    final List<EducationModel> topSkills = [];
    final List<EducationModel> bottomSkills = [];
    for (int i = 0; i < skillsData.length; i++) {
      if (i % 2 == 0) {
        topSkills.add(skillsData[i]);
      } else {
        bottomSkills.add(skillsData[i]);
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: kSpacing20,
      children: [
        Transform.translate(
          offset: const Offset(-40, 0),
          child: SizedBox(
            height: size.height * 0.15,
            child: PageView.builder(
              controller: topController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final skill = topSkills[index % topSkills.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpacing8),
                  child: EducationCard(
                    provider: skill.provider,
                    size: size,
                    title: skill.title,
                    description: skill.description,
                    imagePath: skill.imagePath,
                  ),
                );
              },
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(40, 0),
          child: SizedBox(
            height: size.height * 0.15,
            child: PageView.builder(
              controller: bottomController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final skill = bottomSkills[index % bottomSkills.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kSpacing8),
                  child: EducationCard(
                    size: size,
                    title: skill.title,
                    description: skill.description,
                    imagePath: skill.imagePath,
                    provider: skill.provider,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
