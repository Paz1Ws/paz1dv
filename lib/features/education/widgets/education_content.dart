import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:paz1dv/config/config.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/features/education/domain/models/education_model.dart';
import 'package:paz1dv/features/education/widgets/education_card.dart';

class GridLayout extends StatelessWidget {
  const GridLayout({
    super.key,
    required this.size,
    required this.skillsData,
    required this.animate,
  });

  final Size size;
  final List<EducationModel> skillsData;
  final bool animate;

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
        return animate
            ? FadeInUp(
                duration: const Duration(milliseconds: 800),
                delay: Duration(milliseconds: 150 * index),
                child: EducationCard(
                  size: size,
                  title: skill.title,
                  description: skill.description,
                  imagePath: skill.imagePath,
                  provider: skill.provider,
                ),
              )
            : EducationCard(
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
    required this.animate,
  });

  final Size size;
  final PageController topController;
  final PageController bottomController;
  final List<EducationModel> skillsData;
  final bool animate;

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
        animate
            ? SlideInLeft(
                duration: const Duration(milliseconds: 800),
                from: 100,
                child: TopCarousel(
                  size: size,
                  controller: topController,
                  skills: topSkills,
                ),
              )
            : TopCarousel(
                size: size,
                controller: topController,
                skills: topSkills,
              ),
        animate
            ? SlideInRight(
                duration: const Duration(milliseconds: 800),
                from: 100,
                child: BottomCarousel(
                  size: size,
                  controller: bottomController,
                  skills: bottomSkills,
                ),
              )
            : BottomCarousel(
                size: size,
                controller: bottomController,
                skills: bottomSkills,
              ),
      ],
    );
  }
}

class TopCarousel extends StatelessWidget {
  final Size size;
  final PageController controller;
  final List<EducationModel> skills;

  const TopCarousel({
    super.key,
    required this.size,
    required this.controller,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-40, 0),
      child: SizedBox(
        height: size.height * 0.15,
        child: PageView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final skill = skills[index % skills.length];
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
    );
  }
}

class BottomCarousel extends StatelessWidget {
  final Size size;
  final PageController controller;
  final List<EducationModel> skills;

  const BottomCarousel({
    super.key,
    required this.size,
    required this.controller,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(40, 0),
      child: SizedBox(
        height: size.height * 0.15,
        child: PageView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final skill = skills[index % skills.length];
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
    );
  }
}
