import 'package:cupid_date/core/theme/app_radius.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = Theme.of(context).extension<AppRadius>()!;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color.tertiary,
          foregroundColor: color.onTertiary,
          textStyle: text.labelLarge,
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.full),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = Theme.of(context).extension<AppRadius>()!;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color.primary,
          textStyle: text.labelLarge,
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          side: BorderSide(color: color.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.full),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
