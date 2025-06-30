import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class UrlLauncherUtil {
  // Social media URLs
  static const String githubUrl = 'https://github.com/Paz1Ws';
  static const String instagramUrl = 'https://www.instagram.com/paz1_dv/';
  static const String linkedinUrl =
      'https://www.linkedin.com/in/christopher-paz-leon-745760202';
  static const String figmaUrl =
      'https://www.figma.com/team_invite/redeem/rGBa861pNEXetRMq1oPNE1';

  /// Launch URL with error handling
  static Future<void> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  /// Launch GitHub profile
  static Future<void> launchGitHub() async {
    await launchURL(githubUrl);
  }

  /// Launch Instagram profile
  static Future<void> launchInstagram() async {
    await launchURL(instagramUrl);
  }

  /// Launch LinkedIn profile
  static Future<void> launchLinkedIn() async {
    await launchURL(linkedinUrl);
  }

  /// Launch Figma team invite
  static Future<void> launchFigma() async {
    await launchURL(figmaUrl);
  }
}
