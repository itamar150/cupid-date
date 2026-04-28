import 'package:cupid_date/core/theme/app_colors.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:cupid_date/presentation/auth/providers/auth_providers.dart';
import 'package:cupid_date/presentation/auth/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      await ref.read(signInWithGoogleProvider)();
    } on Exception catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('שגיאה בכניסה עם Google. נסה שוב.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(sendOtpProvider).call(email);
      if (mounted) {
        FocusScope.of(context).unfocus();
        await Future<void>.delayed(const Duration(milliseconds: 150));
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => OtpScreen(email: email),
          ),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        final msg = e.toString();
        final match = RegExp(r'after (\d+) second').firstMatch(msg);
        final seconds = match?.group(1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              seconds != null
                  ? 'נסה שוב בעוד $seconds שניות'
                  : 'שגיאה בשליחת הקוד. נסה שוב.',
            ),
          ),
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              _Header(spacing: spacing, text: text),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    spacing.xxl,
                    spacing.xxl,
                    spacing.xxl,
                    spacing.xxxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _GoogleButton(
                        spacing: spacing,
                        text: text,
                        isLoading: _isGoogleLoading,
                        onPressed: _signInWithGoogle,
                      ),
                      SizedBox(height: spacing.lg),
                      _Divider(text: text),
                      SizedBox(height: spacing.lg),
                      _EmailField(
                        controller: _emailController,
                        spacing: spacing,
                        text: text,
                      ),
                      SizedBox(height: spacing.xl),
                      _SendButton(
                        isLoading: _isLoading,
                        onPressed: _sendOtp,
                        text: text,
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
}

class _Header extends StatelessWidget {
  const _Header({required this.spacing, required this.text});

  final AppSpacing spacing;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        spacing.xxl,
        MediaQuery.of(context).padding.top + spacing.xxxl,
        spacing.xxl,
        spacing.xxxl,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/icon/app_icon.png',
            width: 80,
            height: 80,
          ),
          SizedBox(height: spacing.md),
          Text(
            'Hangly',
            style: text.displayLarge?.copyWith(
              color: AppColors.onDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            'בחרו יחד, בלי לריב',
            style: text.bodyLarge?.copyWith(
              color: AppColors.onDark.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({
    required this.spacing,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  final AppSpacing spacing;
  final TextTheme text;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.divider, width: 1.5),
        shape: const StadiumBorder(),
        padding: EdgeInsets.symmetric(vertical: spacing.md),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoogleLogo(),
                SizedBox(width: spacing.sm),
                Text(
                  'המשך עם Google',
                  style: text.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage('assets/icon/google_icon.png'),
      width: 22,
      height: 22,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.text});

  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'או',
            style: text.bodySmall?.copyWith(color: AppColors.textDisabled),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.controller,
    required this.spacing,
    required this.text,
  });

  final TextEditingController controller;
  final AppSpacing spacing;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'כתובת מייל',
          style: text.labelLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: 'alex@example.com',
            hintStyle: const TextStyle(color: AppColors.textDisabled),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.isLoading,
    required this.onPressed,
    required this.text,
  });

  final bool isLoading;
  final VoidCallback onPressed;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isLoading ? null : AppColors.buttonGradient,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isLoading
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: const StadiumBorder(),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onDark,
                  ),
                )
              : Text(
                  'שלח קוד אימות',
                  style: text.labelLarge?.copyWith(
                    color: AppColors.onDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
