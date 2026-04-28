import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HanglyLogoAnimation extends StatefulWidget {
  const HanglyLogoAnimation({
    this.size = 60.0,
    super.key,
  });

  final double size;

  @override
  State<HanglyLogoAnimation> createState() => _HanglyLogoAnimationState();
}

class _HanglyLogoAnimationState extends State<HanglyLogoAnimation>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _ctrl.repeat();
    } else {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final scale = 1.0 + 0.03 * math.sin(2 * math.pi * _ctrl.value);
        return Transform.scale(scale: scale, child: child);
      },
      child: SvgPicture.asset(
        'assets/icon/hangly_logo.svg',
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}
