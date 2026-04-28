import 'package:cupid_date/core/theme/app_colors.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:cupid_date/core/widgets/hangly_logo_animation.dart';
import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final text = Theme.of(context).textTheme;
    final topPadding = MediaQuery.viewPaddingOf(context).top +
        (Navigator.canPop(context) ? kToolbarHeight : 0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        spacing.xxl,
        topPadding + spacing.sm,
        spacing.xxl,
        spacing.md,
      ),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text.titleMedium?.copyWith(
                    color: AppColors.onDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  subtitle,
                  style: text.bodyMedium?.copyWith(
                    color: AppColors.onDark.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.lg),
          const HanglyLogoAnimation(),
        ],
      ),
    );
  }
}
