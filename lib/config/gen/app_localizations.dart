import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Greeting text introducing Christopher Paz León
  ///
  /// In en, this message translates to:
  /// **'HELLO, I´M CHRISTOPHER PAZ LEÓN, \nA CROSS-PLATFORM...'**
  String get profileGreeting;

  /// Mobile part of the profile title
  ///
  /// In en, this message translates to:
  /// **'MOBILE\nENGINEER'**
  String get profileTitleMobile;

  /// Professional description and experience summary
  ///
  /// In en, this message translates to:
  /// **'With over 2 years of experience, I drive ideas into high-impact experiences through functional, sustainable, and scalable solutions, always ensuring an authentic Win-Win with our users.'**
  String get profileDescription;

  /// Scroll indicator text
  ///
  /// In en, this message translates to:
  /// **'SCROLL'**
  String get scrollText;

  /// About page passion statement focusing on purpose-driven development approach
  ///
  /// In en, this message translates to:
  /// **'I work with a purpose-driven approach: each module has a measurable objective and contributes to a seamless customer experience. I prioritize simplicity, learn and adapt technologies only if they improve the product, and maintain strategic communication to solve real problems with elegance and precision.'**
  String get aboutPassion;

  /// Title for the About section
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutTitle;

  /// About page education philosophy statement
  ///
  /// In en, this message translates to:
  /// **'Wisdom is born in practice, not on paper; I draw from varied sources and real challenges to master the essentials in day-to-day work. \nMy education is a continuous adaptation engine that prepares me for any technological challenge.'**
  String get aboutEducation;

  /// Detailed education background and continuous learning approach
  ///
  /// In en, this message translates to:
  /// **'I study Computer Systems Engineering at UPN and completed specialized courses in Flutter and C#.NET backend. I regularly read technical books like The Pragmatic Programmer and Clean Code, applying their principles in mobile interface design and quality code.\n\nI stay updated with articles on Medium and daily.dev to adapt my technology stack and decisions to the pace of the cutting edge.\n\nThis combination of formal education, practical courses, and continuous reading allows me to act with confidence.'**
  String get aboutEducationDetails;

  /// Label for the About Me section
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutLabel;

  /// Label for the Contact section
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactLabel;

  /// Label for the Experience section
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experienceLabel;

  /// Label for the Education section
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get educationLabel;

  /// Label for the Skills section
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsLabel;

  /// Text to know more
  ///
  /// In en, this message translates to:
  /// **'Know more.'**
  String get knowMore;

  /// Label for provider of certificate/award
  ///
  /// In en, this message translates to:
  /// **'for'**
  String get forLabel;

  /// Date range start label
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromLabel;

  /// Date range connector label
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get toLabel;

  /// Current time label for ongoing positions
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get nowLabel;

  /// January month name
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get januaryLabel;

  /// February month name
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get februaryLabel;

  /// March month name
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get marchLabel;

  /// April month name
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get aprilLabel;

  /// May month name
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get mayLabel;

  /// June month name
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get juneLabel;

  /// July month name
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get julyLabel;

  /// August month name
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get augustLabel;

  /// September month name
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get septemberLabel;

  /// October month name
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get octoberLabel;

  /// November month name
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get novemberLabel;

  /// December month name
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get decemberLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
