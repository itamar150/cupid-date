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

    return ClipPath(
      clipper: const _HomeHeaderClipper(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          spacing.xl,
          topPad + spacing.sm,
          spacing.md,
          spacing.lg,
        ),
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            const Positioned(
              top: 26,
              left: 112,
              child: _HeaderSparkle(size: 8, opacity: 0.68),
            ),
            const Positioned(
              top: 58,
              left: 164,
              child: _HeaderSparkle(size: 5, opacity: 0.5),
            ),
            const Positioned(
              top: 24,
              right: 126,
              child: _HeaderSparkle(size: 10, opacity: 0.74),
            ),
            const Positioned(
              top: 72,
              right: 154,
              child: _HeaderSparkle(size: 6, opacity: 0.54),
            ),
            Transform.translate(
              offset: const Offset(-10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _showAccountSheet(context, ref, userName),
                    child: Column(
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
            ),
          ],
        ),
      ),
    );
  }
}

void _showAccountSheet(
  BuildContext context,
  WidgetRef ref,
  String userName,
) {
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: GoogleFonts.varelaRound(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('התנתק'),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(signOutProvider).call();
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class _HeaderSparkle extends StatelessWidget {
  const _HeaderSparkle({required this.size, required this.opacity});

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

class _HomeHeaderClipper extends CustomClipper<Path> {
  const _HomeHeaderClipper();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 16)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height + 12,
        size.width,
        size.height - 16,
      )
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
