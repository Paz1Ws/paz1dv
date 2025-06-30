import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveConstants {
  // Custom breakpoint names for portfolio
  static const String mobile = 'MOBILE';
  static const String tablet = 'TABLET';
  static const String desktop = 'DESKTOP';
  static const String largeDesktop = 'LARGE_DESKTOP';
  static const String ultraWide = 'ULTRA_WIDE';

  // Breakpoint definitions optimized for portfolio layout
  static List<Breakpoint> get breakpoints => [
    // Mobile: 0-600px - Compact layout with minimal elements
    const Breakpoint(start: 0, end: 600, name: mobile),

    // Tablet: 601-1024px - Medium layout with scaled elements
    const Breakpoint(start: 601, end: 1024, name: tablet),

    // Desktop: 1025-1440px - Full layout with all elements
    const Breakpoint(start: 1025, end: 1440, name: desktop),

    // Large Desktop: 1441-1920px - Spacious layout
    const Breakpoint(start: 1441, end: 1920, name: largeDesktop),

    // Ultra Wide: 1921px+ - Extra wide displays
    const Breakpoint(start: 1921, end: double.infinity, name: ultraWide),
  ];

  // Helper methods for common responsive checks
  static bool isMobile(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile;

  static bool isTablet(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isTablet;

  static bool isDesktop(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isDesktop;

  static bool isNarrowScreen(BuildContext context) =>
      ResponsiveBreakpoints.of(context).smallerOrEqualTo(tablet);

  static bool isWideScreen(BuildContext context) =>
      ResponsiveBreakpoints.of(context).largerOrEqualTo(desktop);
}
