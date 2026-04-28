import 'package:cupid_date/core/theme/app_colors.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:cupid_date/core/widgets/home_header.dart';
import 'package:cupid_date/domain/entities/vibe.dart';
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
  late final PageController _pageCtrl;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(viewportFraction: 0.78);
    _pageCtrl.addListener(() {
      final page = _pageCtrl.page?.round() ?? 0;
      if (page != _currentPage) setState(() => _currentPage = page);
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(),
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.xxl,
              spacing.lg,
              spacing.xxl,
              spacing.sm,
            ),
            child: Text(
              'איזה סוג בילוי תרצה',
              style: text.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: Vibe.values.length,
              itemBuilder: (_, index) => AnimatedBuilder(
                animation: _pageCtrl,
                builder: (_, child) {
                  final page =
                      _pageCtrl.hasClients ? (_pageCtrl.page ?? 0) : 0.0;
                  final scale =
                      (1 - (page - index).abs() * 0.15).clamp(0.85, 1.0);
                  return Transform.scale(scale: scale, child: child);
                },
                child: _VibeCard(vibe: Vibe.values[index]),
              ),
            ),
          ),
          SizedBox(height: spacing.md),
          _buildDots(spacing),
          SizedBox(height: spacing.lg),
          _buildSurpriseButton(spacing, text),
          SizedBox(height: spacing.md),
          _buildBottomButtons(spacing),
          SizedBox(height: spacing.lg + bottomPad),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xxl),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: () {
            // TODO(dev): surprise mode — system picks vibe + venue
          },
          icon: const Icon(Icons.auto_awesome, size: 18),
          label: Text(
            'תפתיע אותנו!',
            style: text.labelLarge?.copyWith(color: AppColors.onDark),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            shape: const StadiumBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(AppSpacing spacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BottomIconButton(
            icon: Icons.tune_rounded,
            onTap: () {
              // TODO(dev): open search settings sheet
            },
          ),
          _BottomIconButton(
            icon: Icons.group_add_outlined,
            onTap: () {
              // TODO(dev): open add partner screen
            },
          ),
        ],
      ),
    );
  }
}

class _VibeCard extends StatelessWidget {
  const _VibeCard({required this.vibe});

  final Vibe vibe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO(dev): navigate to venue results for this vibe
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: vibe.cardColor,
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
                child: Container(color: vibe.cardColor),
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
                bottom: 28,
                left: 0,
                right: 0,
                child: Text(
                  vibe.label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.heebo(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomIconButton extends StatelessWidget {
  const _BottomIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 22),
      ),
    );
  }
}
