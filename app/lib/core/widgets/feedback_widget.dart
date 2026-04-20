import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

enum FeedbackTag { wow, fine, ok, notForUs }

extension FeedbackTagExtension on FeedbackTag {
  String get label => switch (this) {
        FeedbackTag.wow => '🔥 וואו',
        FeedbackTag.fine => '👍 סבבה',
        FeedbackTag.ok => '😐 בסדר',
        FeedbackTag.notForUs => '👎 לא בשבילנו',
      };
}

class FeedbackWidget extends StatelessWidget {
  const FeedbackWidget({
    required this.onStarTap,
    required this.onBrokenHeartTap,
    required this.onTagSelected,
    required this.showTags,
    super.key,
  });

  final VoidCallback onStarTap;
  final VoidCallback onBrokenHeartTap;
  final ValueChanged<FeedbackTag> onTagSelected;
  final bool showTags;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final text = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('איך היה הדייט?', style: text.titleLarge),
        SizedBox(height: spacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ReactionButton(
              emoji: '⭐',
              onTap: onStarTap,
            ),
            SizedBox(width: spacing.xxl),
            _ReactionButton(
              emoji: '💔',
              onTap: onBrokenHeartTap,
            ),
          ],
        ),
        if (showTags) ...[
          SizedBox(height: spacing.xl),
          Wrap(
            spacing: spacing.sm,
            runSpacing: spacing.sm,
            alignment: WrapAlignment.center,
            children: FeedbackTag.values
                .map(
                  (tag) => ActionChip(
                    label: Text(
                      tag.label,
                      style: text.labelLarge?.copyWith(color: color.onSurface),
                    ),
                    onPressed: () => onTagSelected(tag),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.emoji,
    required this.onTap,
  });

  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        height: 72,
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 48)),
        ),
      ),
    );
  }
}
