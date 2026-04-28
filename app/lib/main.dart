import 'package:cupid_date/core/config/supabase_config.dart';
import 'package:cupid_date/core/theme/app_theme.dart';
import 'package:cupid_date/core/widgets/splash_screen.dart';
import 'package:cupid_date/presentation/auth/providers/auth_providers.dart';
import 'package:cupid_date/presentation/auth/screens/login_screen.dart';
import 'package:cupid_date/presentation/home/screens/vibe_selection_screen.dart';
import 'package:cupid_date/presentation/onboarding/screens/hang_profile_screen.dart';
import 'package:cupid_date/presentation/onboarding/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  FlutterNativeSplash.remove();
  runApp(const _Root());
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: ProviderScope(
        child: Stack(
          children: [
            CupidDateApp(),
            SplashScreen(),
          ],
        ),
      ),
    );
  }
}

class CupidDateApp extends ConsumerWidget {
  const CupidDateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(isAuthenticatedProvider);

    return MaterialApp(
      title: 'Hangly',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: authState.when(
        data: (isAuth) {
          if (!isAuth) return const LoginScreen();
          return const _ProfileGate();
        },
        loading: () => const Scaffold(backgroundColor: Color(0xFF162040)),
        error: (_, __) => const LoginScreen(),
      ),
    );
  }
}

class _ProfileGate extends ConsumerWidget {
  const _ProfileGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileExistsProvider);
    return profileState.when(
      data: (exists) =>
          exists ? const _VibeGate() : const UserProfileScreen(),
      loading: () => const Scaffold(backgroundColor: Color(0xFF162040)),
      error: (_, __) => const UserProfileScreen(),
    );
  }
}

class _VibeGate extends ConsumerWidget {
  const _VibeGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibeState = ref.watch(vibeProfileCompleteProvider);
    return vibeState.when(
      data: (complete) =>
          complete ? const VibeSelectionScreen() : const VibeProfileScreen(),
      loading: () => const Scaffold(backgroundColor: Color(0xFF162040)),
      error: (_, __) => const VibeProfileScreen(),
    );
  }
}
