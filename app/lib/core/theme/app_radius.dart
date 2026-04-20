import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class AppRadius extends ThemeExtension<AppRadius> {
  const AppRadius({
    required this.small,
    required this.medium,
    required this.large,
    required this.full,
  });

  static const AppRadius instance = AppRadius(
    small: 8,
    medium: 16,
    large: 24,
    full: 999,
  );

  final double small;
  final double medium;
  final double large;
  final double full;

  @override
  AppRadius copyWith({
    double? small,
    double? medium,
    double? large,
    double? full,
  }) =>
      AppRadius(
        small: small ?? this.small,
        medium: medium ?? this.medium,
        large: large ?? this.large,
        full: full ?? this.full,
      );

  @override
  AppRadius lerp(AppRadius? other, double t) {
    if (other == null) return this;
    return AppRadius(
      small: lerpDouble(small, other.small, t) ?? small,
      medium: lerpDouble(medium, other.medium, t) ?? medium,
      large: lerpDouble(large, other.large, t) ?? large,
      full: lerpDouble(full, other.full, t) ?? full,
    );
  }
}
