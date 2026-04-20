import 'package:cupid_date/core/theme/app_radius.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

enum Vibe { calm, loud, active, food, nature }

extension VibeExtension on Vibe {
  String get label => switch (this) {
        Vibe.calm => 'רגוע',
        Vibe.loud => 'רועש',
        Vibe.active => 'אקטיבי',
        Vibe.food => 'אוכל',
        Vibe.nature => 'טבע',
      };

  String get icon => switch (this) {
        Vibe.calm => '🌿',
        Vibe.loud => '🎉',
        Vibe.active => '🏃',
        Vibe.food => '🍽️',
        Vibe.nature => '🌄',
      };
}

class VibeChip extends StatelessWidget {
  const VibeChip({
    required this.vibe,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final Vibe vibe;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = Theme.of(context).extension<AppRadius>()!;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 48),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.primary : color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(radius.small),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(vibe.icon, style: const TextStyle(fontSize: 18)),
            SizedBox(width: spacing.xs),
            Text(
              vibe.label,
              style: text.labelLarge?.copyWith(
                color: isSelected ? color.onPrimary : color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
