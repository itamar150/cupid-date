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

    return ClipPath(
      clipper: const _OnboardingHeaderClipper(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          spacing.xxl,
          topPadding + spacing.sm,
          spacing.xxl,
          spacing.xl,
        ),
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            const Positioned(
              top: 20,
              left: 80,
              child: _Sparkle(size: 8, opacity: 0.68),
            ),
            const Positioned(
              top: 55,
              left: 140,
              child: _Sparkle(size: 5, opacity: 0.5),
            ),
            const Positioned(
              top: 18,
              right: 100,
              child: _Sparkle(size: 10, opacity: 0.74),
            ),
            const Positioned(
              top: 60,
              right: 130,
              child: _Sparkle(size: 6, opacity: 0.54),
            ),
            Row(
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
          ],
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome,
      size: size,
      color: AppColors.onDark.withValues(alpha: opacity),
    );
  }
}

class _OnboardingHeaderClipper extends CustomClipper<Path> {
  const _OnboardingHeaderClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 16)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height + 12,
        size.width,
        size.height - 16,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
