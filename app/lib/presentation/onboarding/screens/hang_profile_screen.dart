import 'package:cupid_date/core/theme/app_colors.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:cupid_date/core/widgets/onboarding_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VibeProfileScreen extends ConsumerStatefulWidget {
  const VibeProfileScreen({super.key});

  @override
  ConsumerState<VibeProfileScreen> createState() => _VibeProfileScreenState();
}

class _VibeProfileScreenState extends ConsumerState<VibeProfileScreen> {
  final Set<String> _selected = {};
  bool _isLoading = false;

  static const _hangs = [
    ('טיול', '🥾'),
    ('מסעדה / קפה', '🍽️'),
    ('ספא', '💆'),
    ('הופעות', '🎤'),
    ('קולנוע', '🎬'),
    ('טיפוס קיר', '🧗'),
    ('ריקוד', '💃'),
    ('סדנאות', '🛠️'),
    ('בר', '🍸'),
    ('מוזיאון', '🏛️'),
    ('חדר בריחה', '🔒'),
    ('מסיבות', '🎉'),
    ('קמפינג', '⛺'),
    ('סטנדאפ', '🎙️'),
  ];

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      await Supabase.instance.client
          .from('preferences')
          .update({'vibe_profile': _selected.toList()})
          .eq('user_id', userId);

    } on Exception catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('שגיאה בשמירה. נסה שוב.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: Navigator.canPop(context)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.onDark),
            )
          : null,
      body: Column(
        children: [
          const OnboardingHeader(
            title: 'מה אתם אוהבים?',
            subtitle: 'בחרו כמה שרוצים 👇',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.xl),
              child: Wrap(
                spacing: spacing.md,
                runSpacing: spacing.md,
                alignment: WrapAlignment.center,
                children: _hangs.map((v) {
                  final (label, emoji) = v;
                  final isSelected = _selected.contains(label);
                  return _VibeChip(
                    label: label,
                    emoji: emoji,
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      if (isSelected) {
                        _selected.remove(label);
                      } else {
                        _selected.add(label);
                      }
                    }),
                  );
                }).toList(),
              ),
            ),
          ),
          _buildButton(spacing, text),
        ],
      ),
    );
  }

  Widget _buildButton(AppSpacing spacing, TextTheme text) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        spacing.xxl,
        spacing.md,
        spacing.xxl,
        spacing.xxl + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: FilledButton(
          onPressed: _isLoading ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            shape: const StadiumBorder(),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onDark,
                  ),
                )
              : Text(
                  'המשך ←',
                  style: text.labelLarge?.copyWith(color: AppColors.onDark),
                ),
        ),
      ),
    );
  }
}

class _VibeChip extends StatefulWidget {
  const _VibeChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_VibeChip> createState() => _VibeChipState();
}

class _VibeChipState extends State<_VibeChip> {
  bool _pressed = false;

  void _handleTap() {
    setState(() => _pressed = true);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _pressed = false);
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _pressed ? 1.15 : 1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isSelected
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.surface,
            border: Border.all(
              color:
                  widget.isSelected ? AppColors.primary : AppColors.divider,
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: text.labelSmall?.copyWith(
                    color: widget.isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: widget.isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 10,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
