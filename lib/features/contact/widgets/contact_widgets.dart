import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paz1dv/config/app/app_icons.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';
import 'package:paz1dv/config/constants/responsive_constants.dart';
import 'package:paz1dv/config/gen/app_localizations.dart';
import 'package:paz1dv/features/contact/screens/contact_screen.dart';
import 'package:paz1dv/shared/util/url_launcher_util.dart';
import 'package:paz1dv/config/app/text_validations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ContactForm extends ConsumerStatefulWidget {
  const ContactForm({super.key});

  @override
  ConsumerState<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends ConsumerState<ContactForm> {
  bool _isHovered = false;
  String? _selectedBenefit;
  bool _isSubmitting = false;

  // Validation state
  String? _emailError;
  String? _subjectError;
  String? _messageError;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedBenefit = 'consultoria';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _validateFields(AppLocalizations localizations) {
    setState(() {
      _emailError = TextValidations.validateEmail(
        _emailController.text,
        localizations,
      );
      _subjectError = TextValidations.validateSubject(
        _subjectController.text,
        localizations,
      );
      _messageError = TextValidations.validateMessage(
        _messageController.text,
        localizations,
      );
    });
  }

  Future<void> _submitForm(AppLocalizations localizations) async {
    // Validate all fields first
    _validateFields(localizations);

    // Check if there are any validation errors
    if (_emailError != null || _subjectError != null || _messageError != null) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final selectedBenefitText = _getSelectedBenefitText();
      final fullMessage =
          '''${localizations.selectedBenefit}: $selectedBenefitText \n${_messageController.text} ''';

      await UrlLauncherUtil.launchEmail(
        email: 'flutterize1@gmail.com',
        subject: _subjectController.text.isEmpty
            ? 'Contacto desde Portfolio'
            : _subjectController.text,
        body: fullMessage,
      );

      setState(() {
        _isSubmitting = false;
        // Clear validation errors on success
        _emailError = null;
        _subjectError = null;
        _messageError = null;
      });

      // Clear form after successful submission
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();

      // Show success snackbar
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${localizations.sendLabel} ✔',
              style: AppTypography.bodySmall(
                context,
                color: AppPalette.darkMode,
              ),
            ),
            backgroundColor: AppPalette.primaryColor(context),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.errorSendingMessage,
              style: AppTypography.bodySmall(
                context,
                color: AppPalette.lightMode,
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _getSelectedBenefitText() {
    final localizations = AppLocalizations.of(context)!;
    switch (_selectedBenefit) {
      case 'evaluacion':
        return localizations.benefitTechnicalEvaluation;
      case 'consultoria':
        return localizations.benefitExpressConsultation;
      case 'evaluacion_rapida':
        return localizations.benefitQuickEvaluation;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final showBenefits = ref.watch(showBenefitsProvider);
    final selectedKanji = ref.watch(selectedKanjiProvider);
    final localizations = AppLocalizations.of(context)!;
    final isNarrow = ResponsiveConstants.isNarrowScreen(context);
    return Stack(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: FittedBox(
            child: Center(
              child: FadeIn(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  constraints: const BoxConstraints(maxWidth: 600),
                  margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.06,
                    horizontal: size.width * 0.03,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.04,
                    horizontal: size.width * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.darkMode,
                    border: Border.all(
                      color: _isHovered
                          ? AppPalette.primaryColor(context).withAlpha(180)
                          : AppPalette.lightMode.withAlpha(180),
                      width: 2,
                    ),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: AppPalette.primaryColor(
                                context,
                              ).withAlpha(50),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: size.height * 0.025,
                    children: [
                      // Top border lines
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: size.width * 0.01,
                          children: [
                            _BorderLine(isHovered: _isHovered),
                            _BorderLine(isHovered: _isHovered),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kPadding8,
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: AppTypography.heading2(
                            context,
                            color: _isHovered
                                ? AppPalette.primaryColor(context)
                                : AppPalette.lightMode,
                          ),
                          child: Text(
                            localizations.mayIHelpYou,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Email & Subject
                      Row(
                        spacing: size.width * 0.03,
                        children: [
                          Expanded(
                            child: _InputColumn(
                              controller: _emailController,
                              label: localizations.contactEmailLabel,
                              hint: localizations.contactEmailHint,
                              errorText: _emailError,
                              onChanged: (value) {
                                if (_emailError != null) {
                                  setState(() {
                                    _emailError = TextValidations.validateEmail(
                                      value,
                                      localizations,
                                    );
                                  });
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: _InputColumn(
                              controller: _subjectController,
                              label: localizations.contactSubjectLabel,
                              hint: localizations.contactSubjectHint,
                              errorText: _subjectError,
                              onChanged: (value) {
                                if (_subjectError != null) {
                                  setState(() {
                                    _subjectError =
                                        TextValidations.validateSubject(
                                          value,
                                          localizations,
                                        );
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      // Kanji discover/benefit section
                      _KanjiDiscoverMessage(
                        localizations: localizations,
                        size: size,
                        selectedKanji: selectedKanji,
                        showBenefits: showBenefits,
                        isNarrow: isNarrow,
                      ),
                      if (showBenefits)
                        FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          child: Column(
                            spacing: size.height * 0.018,
                            children: [
                              _BenefitCard(
                                id: 'evaluacion',
                                icon: '✅',
                                title: localizations.benefitTechnicalEvaluation,
                                description: localizations
                                    .benefitTechnicalEvaluationDesc,
                                benefits: [
                                  localizations
                                      .benefitTechnicalEvaluationPoint1,
                                  localizations
                                      .benefitTechnicalEvaluationPoint2,
                                  localizations
                                      .benefitTechnicalEvaluationPoint3,
                                ],
                                isSelected: _selectedBenefit == 'evaluacion',
                                onTap: () => setState(
                                  () => _selectedBenefit = 'evaluacion',
                                ),
                                animationDelay: 100,
                              ),
                              _BenefitCard(
                                id: 'consultoria',
                                icon: '🚀',
                                title: localizations.benefitExpressConsultation,
                                description: localizations
                                    .benefitExpressConsultationDesc,
                                benefits: [
                                  localizations
                                      .benefitExpressConsultationPoint1,
                                  localizations
                                      .benefitExpressConsultationPoint2,
                                  localizations
                                      .benefitExpressConsultationPoint3,
                                  localizations
                                      .benefitExpressConsultationPoint4,
                                ],
                                isSelected: _selectedBenefit == 'consultoria',
                                onTap: () => setState(
                                  () => _selectedBenefit = 'consultoria',
                                ),
                                animationDelay: 200,
                                isSpecial: true,
                              ),
                              _BenefitCard(
                                id: 'evaluacion_rapida',
                                icon: '💡',
                                title: localizations.benefitQuickEvaluation,
                                description:
                                    localizations.benefitQuickEvaluationDesc,
                                benefits: [
                                  localizations.benefitQuickEvaluationPoint1,
                                  localizations.benefitQuickEvaluationPoint2,
                                  localizations.benefitQuickEvaluationPoint3,
                                  localizations.benefitQuickEvaluationPoint4,
                                ],
                                isSelected:
                                    _selectedBenefit == 'evaluacion_rapida',
                                onTap: () => setState(
                                  () => _selectedBenefit = 'evaluacion_rapida',
                                ),
                                animationDelay: 300,
                              ),
                            ],
                          ),
                        ),
                      // Message input (always visible)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          localizations.message,
                          style: AppTypography.bodySmallBold(
                            context,
                            color: AppPalette.lightMode,
                          ),
                        ),
                      ),
                      _MessageInput(
                        controller: _messageController,
                        localizations: localizations,
                        size: size,
                        errorText: _messageError,
                        onChanged: (value) {
                          if (_messageError != null) {
                            setState(() {
                              _messageError = TextValidations.validateMessage(
                                value,
                                localizations,
                              );
                            });
                          }
                        },
                      ),
                      // Send Button
                      SizedBox(
                        width: double.infinity,
                        child: Material(
                          color: _isSubmitting
                              ? AppPalette.mutedGray
                              : AppPalette.lightMode,
                          borderRadius: BorderRadius.circular(kRadius8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(kRadius8),
                            onTap: _isSubmitting
                                ? null
                                : () => _submitForm(localizations),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.018,
                              ),
                              child: Center(
                                child: _isSubmitting
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppPalette.darkMode,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        localizations.sendLabel,
                                        style: AppTypography.bodyLargeBold(
                                          context,
                                          color: AppPalette.darkMode,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Bottom border lines
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: size.width * 0.01,
                          children: [
                            _BorderLine(isHovered: _isHovered),
                            _BorderLine(isHovered: _isHovered),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BorderLine extends StatelessWidget {
  final bool isHovered;
  const _BorderLine({required this.isHovered});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 2,
      color: isHovered
          ? AppPalette.primaryColor(context)
          : AppPalette.lightMode,
    );
  }
}

class _KanjiDiscoverMessage extends StatelessWidget {
  final AppLocalizations localizations;
  final Size size;
  final String? selectedKanji;
  final bool showBenefits;
  final bool isNarrow;

  const _KanjiDiscoverMessage({
    required this.localizations,
    required this.size,
    required this.selectedKanji,
    required this.showBenefits,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    String displayText;
    IconData displayIcon;
    bool isKanjiSelected = selectedKanji != null;
    if (isKanjiSelected && selectedKanji == '永' && showBenefits) {
      displayText =
          '(${_getKanjiMeaning(selectedKanji!, localizations)}) - ${selectedKanji!} - ${localizations.kanjiFavorite}';
      displayIcon = Icons.auto_awesome;
    } else if (isKanjiSelected && !showBenefits) {
      // Regular kanji selected (including eternity without benefits)
      String meaning = _getKanjiMeaning(selectedKanji!, localizations);
      displayText = '${selectedKanji!} ($meaning)';
      displayIcon = Icons.info;
    } else if (!isKanjiSelected) {
      // No kanji selected
      displayText = localizations.discoverKanjiMessage;
      displayIcon = Icons.explore;
    } else {
      // Fallback
      displayText = localizations.discoverKanjiMessage;
      displayIcon = Icons.explore;
    }

    return Container(
      padding: EdgeInsets.all(size.width * 0.02),
      decoration: BoxDecoration(
        color: isKanjiSelected
            ? AppPalette.primaryColor(context).withAlpha(25)
            : AppPalette.lightGray.withAlpha(20),
        borderRadius: BorderRadius.circular(kRadius12),
        border: Border.all(
          color: isKanjiSelected
              ? AppPalette.primaryColor(context).withAlpha(180)
              : AppPalette.lightMode.withAlpha(60),
          width: isKanjiSelected ? 2 : 1,
        ),
        boxShadow: isKanjiSelected
            ? [
                BoxShadow(
                  color: AppPalette.primaryColor(context).withAlpha(30),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        spacing: size.width * 0.02,
        children: [
          Icon(
            displayIcon,
            color: isKanjiSelected
                ? AppPalette.primaryColor(context)
                : AppPalette.lightMode.withAlpha(150),
            size: isNarrow ? size.width * 0.05 : size.width * 0.02,
          ),
          Expanded(
            child: Text(
              displayText,
              style: AppTypography.bodySmall(
                context,
                color: isKanjiSelected
                    ? AppPalette.primaryColor(context)
                    : AppPalette.lightMode.withAlpha(180),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getKanjiMeaning(String kanji, AppLocalizations localizations) {
    switch (kanji) {
      case '知':
        return localizations.kanjiKnowledge;
      case '美':
        return localizations.kanjiBeauty;
      case '忍':
        return localizations.kanjiPatience;
      case '誠':
        return localizations.kanjiSincerity;
      case '志':
        return localizations.kanjiWill;
      case '永':
        return localizations.kanjiEternity;
      default:
        return '';
    }
  }
}

class _InputColumn extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _InputColumn({
    required this.label,
    required this.hint,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: size.height * 0.01,
      children: [
        Text(
          label,
          style: AppTypography.bodySmallBold(
            context,
            color: AppPalette.lightMode,
          ),
          maxLines: 1,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppPalette.lightGray.withAlpha(30),
            borderRadius: BorderRadius.circular(kRadius8),
            border: errorText != null
                ? Border.all(color: Colors.red, width: 1)
                : null,
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 2,
            style: AppTypography.bodySmall(
              context,
              color: AppPalette.lightMode,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodySmall(
                context,
                color: AppPalette.lightMode.withAlpha(120),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.018,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.005),
            child: Text(
              errorText!,
              style: AppTypography.caption(context, color: Colors.red),
            ),
          ),
      ],
    );
  }
}

class _MessageInput extends StatelessWidget {
  final AppLocalizations localizations;
  final Size size;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _MessageInput({
    required this.localizations,
    required this.size,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: size.height * 0.01,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppPalette.lightGray.withAlpha(30),
            borderRadius: BorderRadius.circular(kRadius8),
            border: errorText != null
                ? Border.all(color: Colors.red, width: 1)
                : null,
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 2,
            style: AppTypography.bodySmall(
              context,
              color: AppPalette.lightMode,
            ),
            decoration: InputDecoration(
              hintText: localizations.messagePlaceholder,
              hintStyle: AppTypography.bodySmall(
                context,
                color: AppPalette.lightMode.withAlpha(120),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03,
                vertical: size.height * 0.018,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.005),
            child: Text(
              errorText!,
              style: AppTypography.caption(context, color: Colors.red),
            ),
          ),
      ],
    );
  }
}

class _BenefitCard extends StatefulWidget {
  final String id;
  final String icon;
  final String title;
  final String description;
  final List<String> benefits;
  final bool isSelected;
  final VoidCallback onTap;
  final int animationDelay;
  final bool isSpecial;

  const _BenefitCard({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.benefits,
    required this.isSelected,
    required this.onTap,
    required this.animationDelay,
    this.isSpecial = false,
  });

  @override
  State<_BenefitCard> createState() => _BenefitCardState();
}

class _BenefitCardState extends State<_BenefitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _borderController;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _borderController, curve: Curves.easeInOut),
    );

    if (widget.isSpecial) {
      _borderController.repeat();
    }
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_BenefitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected && widget.isSpecial) {
        _borderController.repeat();
      } else if (!widget.isSelected) {
        _borderController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return MouseRegion(
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _borderAnimation,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppPalette.lightMode.withAlpha(15)
                    : AppPalette.lightGray.withAlpha(10),
                borderRadius: BorderRadius.circular(kRadius12),
                border: widget.isSpecial && widget.isSelected
                    ? Border.all(
                        width: 2,
                        color: Color.lerp(
                          AppPalette.lightMode,
                          AppPalette.primaryColor(context),
                          _borderAnimation.value,
                        )!,
                      )
                    : Border.all(
                        width: widget.isSelected ? 2 : 1,
                        color: widget.isSelected
                            ? AppPalette.lightMode
                            : AppPalette.lightMode.withAlpha(60),
                      ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: widget.isSpecial
                              ? AppPalette.primaryColor(context).withAlpha(30)
                              : AppPalette.lightMode.withAlpha(20),
                          blurRadius: widget.isSpecial ? 12 : 8,
                          spreadRadius: widget.isSpecial ? 2 : 1,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: size.height * 0.012,
                children: [
                  Row(
                    spacing: size.width * 0.02,
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.009),
                        decoration: BoxDecoration(
                          color: widget.isSelected
                              ? AppPalette.lightMode.withAlpha(25)
                              : AppPalette.lightMode.withAlpha(15),
                          borderRadius: BorderRadius.circular(kRadius8),
                        ),
                        child: Text(
                          widget.icon,
                          style: TextStyle(fontSize: size.width * 0.02),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: AppTypography.bodyMediumBold(
                            context,
                            color: widget.isSelected
                                ? AppPalette.lightMode
                                : AppPalette.lightMode.withAlpha(200),
                          ),
                        ),
                      ),
                      // Selection indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: size.width * 0.02,
                        height: size.width * 0.02,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isSelected
                              ? AppPalette.lightMode
                              : Colors.transparent,
                          border: Border.all(
                            color: AppPalette.lightMode.withAlpha(120),
                            width: 1,
                          ),
                        ),
                        child: widget.isSelected
                            ? Icon(
                                Icons.check,
                                size: size.width * 0.01,
                                color: AppPalette.darkMode,
                              )
                            : null,
                      ),
                    ],
                  ),
                  Text(
                    widget.description,
                    style: AppTypography.bodySmall(
                      context,
                      color: AppPalette.lightMode.withAlpha(180),
                    ),
                  ),
                  Column(
                    spacing: size.height * 0.006,
                    children: widget.benefits
                        .map(
                          (benefit) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: size.width * 0.015,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: size.height * 0.008,
                                ),
                                width: size.width * 0.005,
                                height: size.width * 0.005,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppPalette.lightMode.withAlpha(150),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: AppTypography.bodySmall(
                                    context,
                                    color: AppPalette.lightMode.withAlpha(160),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
