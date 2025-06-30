import 'package:flutter/material.dart';
import 'package:paz1dv/config/app/app_palette.dart';
import 'package:paz1dv/config/app/app_typography.dart';
import 'package:paz1dv/config/constants/layer_constants.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 600;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsets.symmetric(
          vertical: kSpacing50,
          horizontal: kSpacing20,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: kSpacing30,
          horizontal: kSpacing30,
        ),
        decoration: BoxDecoration(
          color: AppPalette.darkMode,
          border: Border.all(
            color: AppPalette.lightMode.withAlpha(180),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top border lines
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 40, height: 2, color: AppPalette.lightMode),
                Container(width: 40, height: 2, color: AppPalette.lightMode),
              ],
            ),
            const SizedBox(height: kSpacing20),
            // Title
            Text(
              "CONTACTO",
              style: AppTypography.heading2(
                context,
                color: AppPalette.lightMode,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kSpacing30),
            // Email & Subject
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tu correo",
                        style: AppTypography.bodySmallBold(
                          context,
                          color: AppPalette.lightMode,
                        ),
                      ),
                      const SizedBox(height: kSpacing8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppPalette.lightGray.withAlpha(30),
                          borderRadius: BorderRadius.circular(kRadius8),
                        ),
                        child: TextField(
                          style: AppTypography.bodySmall(
                            context,
                            color: AppPalette.lightMode,
                          ),
                          decoration: InputDecoration(
                            hintText: "ejemplo@correo.com",
                            hintStyle: AppTypography.bodySmall(
                              context,
                              color: AppPalette.lightMode.withAlpha(120),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: kSpacing12,
                              vertical: kSpacing12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: kSpacing20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Asunto",
                        style: AppTypography.bodySmallBold(
                          context,
                          color: AppPalette.lightMode,
                        ),
                      ),
                      const SizedBox(height: kSpacing8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppPalette.lightGray.withAlpha(30),
                          borderRadius: BorderRadius.circular(kRadius8),
                        ),
                        child: TextField(
                          style: AppTypography.bodySmall(
                            context,
                            color: AppPalette.lightMode,
                          ),
                          decoration: InputDecoration(
                            hintText: "Asunto",
                            hintStyle: AppTypography.bodySmall(
                              context,
                              color: AppPalette.lightMode.withAlpha(120),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: kSpacing12,
                              vertical: kSpacing12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpacing20),
            // Message
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mensaje",
                style: AppTypography.bodySmallBold(
                  context,
                  color: AppPalette.lightMode,
                ),
              ),
            ),
            const SizedBox(height: kSpacing8),
            Container(
              decoration: BoxDecoration(
                color: AppPalette.lightGray.withAlpha(30),
                borderRadius: BorderRadius.circular(kRadius8),
              ),
              child: TextField(
                maxLines: 6,
                style: AppTypography.bodySmall(
                  context,
                  color: AppPalette.lightMode,
                ),
                decoration: InputDecoration(
                  hintText: "Tu mensaje",
                  hintStyle: AppTypography.bodySmall(
                    context,
                    color: AppPalette.lightMode.withAlpha(120),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: kSpacing12,
                    vertical: kSpacing12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: kSpacing30),
            // Send Button
            SizedBox(
              width: double.infinity,
              child: Material(
                color: AppPalette.lightMode,
                borderRadius: BorderRadius.circular(kRadius8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(kRadius8),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: kSpacing12),
                    child: Center(
                      child: Text(
                        "Enviar",
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
            const SizedBox(height: kSpacing8),
            // Bottom border lines
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 40, height: 2, color: AppPalette.lightMode),
                Container(width: 40, height: 2, color: AppPalette.lightMode),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
