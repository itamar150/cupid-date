import 'dart:math' as math;

import 'package:cupid_date/core/theme/app_colors.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:cupid_date/core/widgets/home_header.dart';
import 'package:cupid_date/domain/entities/gender.dart';
import 'package:cupid_date/domain/entities/vibe.dart';
import 'package:cupid_date/presentation/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class VibeSelectionScreen extends ConsumerStatefulWidget {
  const VibeSelectionScreen({super.key});

  @override
  ConsumerState<VibeSelectionScreen> createState() =>
      _VibeSelectionScreenState();
}

class _VibeSelectionScreenState extends ConsumerState<VibeSelectionScreen> {
  static const int _loopMultiplier = 1000;
  late final PageController _pageCtrl;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final initialPage = Vibe.values.length * (_loopMultiplier ~/ 2);
    _currentPage = initialPage % Vibe.values.length;
    _pageCtrl = PageController(
      viewportFraction: 0.7,
      initialPage: initialPage,
    );
    _pageCtrl.addListener(() {
      final page =
          (_pageCtrl.page?.round() ?? initialPage) % Vibe.values.length;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final text = Theme.of(context).textTheme;
    final bottomPad = MediaQuery.viewPaddingOf(context).bottom;
    final size = MediaQuery.sizeOf(context);
    final carouselHeight = math.min(size.height * 0.396, 387).toDouble();
    final gender = Gender.fromValue(
      ref.watch(currentUserGenderProvider).valueOrNull ?? 1,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeader(),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.xxl,
                  spacing.lg,
                  spacing.xxl,
                  spacing.sm,
                ),
                child: Column(
                  children: [
                    Text(
                      "איזה סוג בילוי ${gender.text('תרצה', 'תרצי')}?",
                      textAlign: TextAlign.center,
                      style: text.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: spacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'נמצא את ה- Hang המתאים עבורך',
                          style: text.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: spacing.xs),
                        const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFFD4A437),
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.xl),
              SizedBox(
                height: carouselHeight,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: PageView.builder(
                    controller: _pageCtrl,
                    clipBehavior: Clip.none,
                    itemCount: Vibe.values.length * _loopMultiplier,
                    itemBuilder: (_, index) => AnimatedBuilder(
                      animation: _pageCtrl,
                      builder: (_, child) {
                        final page =
                            _pageCtrl.hasClients
                                ? (_pageCtrl.page ??
                                    _pageCtrl.initialPage.toDouble())
                                : _pageCtrl.initialPage.toDouble();
                        final delta = index - page;
                        final clampedDelta = delta.clamp(-1.0, 1.0);
                        final distance = delta.abs();
                        final scale = (1 - distance * 0.14).clamp(0.84, 1.0);
                        final dy = distance.clamp(0.0, 1.0) * 18;
                        final dx = clampedDelta * 10;
                        final rotateY = -clampedDelta * 0.42;
                        final transform =
                            Matrix4.identity()
                              ..setEntry(3, 2, 0.0012)
                              ..translateByDouble(dx, dy, 0, 1)
                              ..rotateY(rotateY)
                              ..scaleByDouble(scale, scale, 1, 1);

                        return Transform(
                          alignment:
                              clampedDelta < 0
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          transform: transform,
                          child: child,
                        );
                      },
                      child: _VibeCard(
                        vibe: Vibe.values[index % Vibe.values.length],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing.md),
              _buildDots(spacing),
              const Spacer(),
              _buildSurpriseButton(spacing, text),
              SizedBox(height: 90 + bottomPad),
            ],
          ),
          Positioned(
            left: -22,
            bottom: -22,
            child: _EdgeIconButton(
              icon: Icons.tune_sharp,
              alignment: const Alignment(0, -0.7),
              backgroundColor: const Color.fromARGB(255, 220, 220, 248),
              borderColor: const Color.fromARGB(255, 154, 169, 204),
              onTap: () {
                // TODO(dev): open search settings sheet
              },
            ),
          ),
          Positioned(
            right: -22,
            bottom: -22,
            child: _EdgeIconButton(
              icon: Icons.group_add_outlined,
              alignment: const Alignment(0, -0.7),
              backgroundColor: const Color.fromARGB(255, 247, 224, 235),
              borderColor: const Color(0xFFE4AFC6),
              onTap: () {
                // TODO(dev): open add partner screen
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots(AppSpacing spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(Vibe.values.length, (i) {
        final active = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: spacing.xs / 2),
          width: active ? 20 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active ? AppColors.primaryDark : AppColors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildSurpriseButton(AppSpacing spacing, TextTheme text) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 50,
        child: FilledButton(
          onPressed: () {
            // TODO(dev): surprise mode - system picks vibe + venue
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            shape: const StadiumBorder(),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'תפתיעו אותנו! ',
                style: text.labelLarge?.copyWith(
                  color: AppColors.onDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: spacing.xs),
              const Icon(Icons.auto_awesome, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _VibeCard extends StatelessWidget {
  const _VibeCard({required this.vibe});

  final Vibe vibe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: GestureDetector(
        onTap: () {
          // TODO(dev): navigate to venue results for this vibe
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                Positioned.fill(
                  left: -6,
                  right: -6,
                  child: Image.asset(
                    vibe.imageAsset1,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: vibe.cardColor),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                        stops: const [0.45, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 18,
                  left: 0,
                  right: 0,
                  child: Text(
                    vibe.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.heebo(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EdgeIconButton extends StatelessWidget {
  const _EdgeIconButton({
    required this.icon,
    required this.alignment,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
  });

  final IconData icon;
  final Alignment alignment;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Icon(icon, color: AppColors.primaryDark, size: 28),
          ),
        ),
      ),
    );
  }
}
