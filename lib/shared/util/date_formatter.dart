import 'package:flutter/material.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';

class DateFormatter {
  static String formatDateRange(
    BuildContext context,
    DateTime startDate,
    DateTime? endDate,
  ) {
    final localizations = AppLocalizations.of(context)!;
    final startMonth = _getMonthName(context, startDate.month);
    final startYear = startDate.year.toString();

    if (endDate == null) {
      return '${localizations.fromLabel} $startMonth $startYear ${localizations.toLabel} ${localizations.nowLabel}';
    } else {
      final endMonth = _getMonthName(context, endDate.month);
      final endYear = endDate.year.toString();

      if (startYear == endYear) {
        return '${localizations.fromLabel} $startMonth ${startDate.day} ${localizations.toLabel} $endMonth ${endDate.day}, $endYear';
      } else {
        return '${localizations.fromLabel} $startMonth $startYear ${localizations.toLabel} $endMonth $endYear';
      }
    }
  }

  static String _getMonthName(BuildContext context, int month) {
    final localizations = AppLocalizations.of(context)!;

    switch (month) {
      case 1:
        return localizations.januaryLabel;
      case 2:
        return localizations.februaryLabel;
      case 3:
        return localizations.marchLabel;
      case 4:
        return localizations.aprilLabel;
      case 5:
        return localizations.mayLabel;
      case 6:
        return localizations.juneLabel;
      case 7:
        return localizations.julyLabel;
      case 8:
        return localizations.augustLabel;
      case 9:
        return localizations.septemberLabel;
      case 10:
        return localizations.octoberLabel;
      case 11:
        return localizations.novemberLabel;
      case 12:
        return localizations.decemberLabel;
      default:
        return 'Unknown';
    }
  }
}
