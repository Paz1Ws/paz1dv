import 'dart:core';

import 'package:flutter/material.dart';
import 'package:paz1dv/shared/util/date_formatter.dart';

class ExperienceModel {
  final String icon;
  final String backgroundImage;
  final String link;
  final List<String> carouselImages;
  // Translated fields
  final String title;
  final String industry;
  final String client;
  final String service;
  // Dates replaced with start_date and end_date
  final DateTime startDate;
  final DateTime? endDate; // Can be null for current positions
  final String description;

  ExperienceModel({
    required this.icon,
    required this.backgroundImage,
    required this.link,
    required this.carouselImages,
    required this.title,
    required this.industry,
    required this.client,
    required this.service,
    required this.startDate,
    this.endDate,
    required this.description,
  });

  String formattedDateRange(BuildContext context) {
    return DateFormatter.formatDateRange(context, startDate, endDate);
  }

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    final translations = json['experience_translations'] as List;
    if (translations.isEmpty) {
      throw Exception('No translation found for experience ID: ${json['id']}');
    }
    final t = translations.first as Map<String, dynamic>;

    // Parse dates
    DateTime? startDate;
    DateTime? endDate;

    if (json['start_date'] != null) {
      startDate = DateTime.tryParse(json['start_date']);
    }

    if (json['end_date'] != null) {
      endDate = DateTime.tryParse(json['end_date']);
    }

    // If start_date parsing failed, use a fallback date
    startDate ??= DateTime(2023, 1, 1);

    return ExperienceModel(
      icon: json['icon'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      link: json['link'] ?? '',
      carouselImages: List<String>.from(json['carousel_images'] ?? []),
      title: t['title'] ?? '',
      industry: t['industry'] ?? '',
      client: json['client'] ?? '',
      service: t['service'] ?? '',
      startDate: startDate,
      endDate: endDate,
      description: t['description'] ?? '',
    );
  }
}
