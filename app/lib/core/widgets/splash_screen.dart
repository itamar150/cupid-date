import 'dart:async';

import 'package:cupid_date/presentation/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final AnimationController _exitCtrl;
  final Completer<void> _enterDone = Completer<void>();
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _exitOpacity;
  bool _exitStarted = false;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    final curved = CurvedAnimation(
      parent: _enterCtrl,
      curve: Curves.easeOut,
    );
    _logoOpacity = curved;
    _logoScale = Tween<double>(
      begin: 0.75,
      end: 1,
    ).animate(curved);
    _exitOpacity = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_exitCtrl);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await precacheImage(
        const AssetImage('assets/icon/hangly_logo_splash.png'),
        context,
      );
      if (!mounted) return;
      unawaited(_enterCtrl.forward().whenComplete(_enterDone.complete));
      _tryExit();
    });
  }

  void _tryExit() {
    final auth = ref.read(isAuthenticatedProvider);
    if (auth.isLoading) return;

    final isAuth = auth.valueOrNull ?? false;
    if (!isAuth) {
      _exit();
      return;
    }

    final profile = ref.read(profileExistsProvider);
    if (profile.isLoading) return;

    final hasProfile = profile.valueOrNull ?? false;
    if (!hasProfile) {
      _exit();
      return;
    }

    final couple = ref.read(isCoupleLinkedProvider);
    if (couple.isLoading) return;

    _exit();
  }

  Future<void> _exit() async {
    if (_exitStarted) return;
    _exitStarted = true;
    await _enterDone.future;
    if (mounted) await _exitCtrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen<AsyncValue<bool>>(
        isAuthenticatedProvider,
        (_, __) => _tryExit(),
      )
      ..listen<AsyncValue<bool>>(
        profileExistsProvider,
        (_, __) => _tryExit(),
      )
      ..listen<AsyncValue<bool>>(
        isCoupleLinkedProvider,
        (_, __) => _tryExit(),
      );

    return AnimatedBuilder(
      animation: _exitCtrl,
      builder: (_, child) {
        if (_exitCtrl.isCompleted) return const SizedBox.shrink();
        return FadeTransition(
          opacity: _exitOpacity,
          child: child,
        );
      },
      child: SizedBox.expand(
        child: ColoredBox(
          color: const Color(0xFF162040),
          child: Center(
            child: FadeTransition(
              opacity: _logoOpacity,
              child: ScaleTransition(
                scale: _logoScale,
                child: Image.asset(
                  'assets/icon/hangly_logo_splash.png',
                  width: 200,
                  height: 185,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
