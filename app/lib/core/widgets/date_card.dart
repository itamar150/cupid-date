import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupid_date/core/theme/app_radius.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class DateCard extends StatelessWidget {
  const DateCard({
    required this.name,
    required this.vibe,
    required this.rating,
    required this.distanceKm,
    required this.onTap,
    super.key,
    this.imageUrl,
    this.isSurprise = false,
  });

  final String name;
  final String vibe;
  final double rating;
  final double distanceKm;
  final String? imageUrl;
  final bool isSurprise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = Theme.of(context).extension<AppRadius>()!;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final color = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius.medium),
        child: SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(imageUrl, isSurprise),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
              if (isSurprise)
                const Center(
                  child: Text('🎁', style: TextStyle(fontSize: 48)),
                )
              else
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: text.titleMedium?.copyWith(
                            color: color.onPrimary,
                          ),
                        ),
                        SizedBox(height: spacing.xs),
                        Row(
                          children: [
                            Text(
                              '⭐ $rating',
                              style: text.bodyMedium?.copyWith(
                                color: color.onPrimary,
                              ),
                            ),
                            SizedBox(width: spacing.sm),
                            Text(
                              '📍 ${distanceKm.toStringAsFixed(1)} ק"מ',
                              style: text.bodyMedium?.copyWith(
                                color: color.onPrimary,
                              ),
                            ),
                            SizedBox(width: spacing.sm),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing.sm,
                                vertical: spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: color.primary.withValues(alpha: 0.8),
                                borderRadius:
                                    BorderRadius.circular(radius.small),
                              ),
                              child: Text(
                                vibe,
                                style: text.labelSmall?.copyWith(
                                  color: color.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? url, bool surprise) {
    if (surprise || url == null) {
      return Container(color: Colors.grey.shade300);
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(color: Colors.grey.shade300),
      errorWidget: (_, __, ___) => Container(color: Colors.grey.shade300),
    );
  }
}
