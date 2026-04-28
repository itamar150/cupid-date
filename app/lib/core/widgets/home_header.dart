import 'package:cupid_date/core/theme/app_colors.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:cupid_date/presentation/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final topPad = MediaQuery.viewPaddingOf(context).top;
    final userName = ref.watch(currentUserNameProvider).valueOrNull ?? '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        spacing.xxl,
        topPad + spacing.sm,
        spacing.sm,
        spacing.md,
      ),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'היי,',
                style: GoogleFonts.varelaRound(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onDark.withValues(alpha: 0.8),
                ),
              ),
              Text(
                userName,
                style: GoogleFonts.varelaRound(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onDark,
                  height: 1.1,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              'assets/icon/hangly_logo_splash.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
