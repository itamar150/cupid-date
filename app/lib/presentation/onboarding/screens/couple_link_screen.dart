import 'package:cupid_date/core/theme/app_colors.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:cupid_date/core/widgets/onboarding_header.dart';
import 'package:cupid_date/presentation/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoupleLinkScreen extends ConsumerStatefulWidget {
  const CoupleLinkScreen({super.key});

  @override
  ConsumerState<CoupleLinkScreen> createState() => _CoupleLinkScreenState();
}

class _CoupleLinkScreenState extends ConsumerState<CoupleLinkScreen> {
  final _codeController = TextEditingController();
  String? _generatedCode;
  bool _isLoading = false;
  bool _showJoinField = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final existing = await ref
          .read(coupleRepositoryProvider)
          .getExistingCode();
      if (mounted && existing != null) {
        setState(() => _generatedCode = existing);
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _createCouple() async {
    setState(() => _isLoading = true);
    try {
      final code = await ref.read(createCoupleProvider).call();
      if (mounted) setState(() => _generatedCode = code);
    } on Exception catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('שגיאה ביצירת קוד. נסה שוב.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _joinCouple() async {
    final code = _codeController.text.trim();
    if (code.length < 6) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(joinCoupleProvider).call(code);
      ref.invalidate(isCoupleLinkedProvider);
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('כבר')
                  ? 'קוד זה כבר בשימוש'
                  : 'קוד לא תקין. נסה שוב.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _copyCode() {
    if (_generatedCode == null) return;
    Clipboard.setData(ClipboardData(text: _generatedCode!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('הקוד הועתק ללוח')),
    );
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
            title: 'קישור פרטנר ל- Hangly',
            subtitle: 'חברו יחד כדי להתחיל',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.xxl),
              child: _generatedCode != null
                  ? _buildCodeDisplay(spacing, text)
                  : _buildOptions(spacing, text),
            ),
          ),
          if (_showJoinField && _generatedCode == null)
            _buildJoinButton(spacing, text),
        ],
      ),
    );
  }

  Widget _buildOptions(AppSpacing spacing, TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: spacing.xl),
        _OptionCard(
          emoji: '✨',
          title: 'צור קוד הזמנה',
          subtitle: 'שלח לבן/בת הזוג שלך',
          onTap: _isLoading ? null : _createCouple,
          isLoading: _isLoading && !_showJoinField,
          spacing: spacing,
          text: text,
        ),
        SizedBox(height: spacing.lg),
        _OptionCard(
          emoji: '🔗',
          title: 'יש לי קוד',
          subtitle: 'הכנס קוד שקיבלת',
          onTap: _isLoading
              ? null
              : () => setState(() => _showJoinField = !_showJoinField),
          spacing: spacing,
          text: text,
        ),
        if (_showJoinField) ...[
          SizedBox(height: spacing.xl),
          _buildJoinField(spacing, text),
        ],
      ],
    );
  }

  Widget _buildJoinField(AppSpacing spacing, TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'הכנס קוד הזמנה',
          style: text.labelLarge?.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: spacing.sm),
        TextField(
          controller: _codeController,
          textCapitalization: TextCapitalization.characters,
          maxLength: 6,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: text.headlineMedium?.copyWith(
            letterSpacing: 8,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildJoinButton(AppSpacing spacing, TextTheme text) {
    final isValid = _codeController.text.trim().length == 6;
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
        child: FilledButton(
          onPressed: isValid && !_isLoading ? _joinCouple : null,
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
                  'התחבר לפרטנר',
                  style: text.labelLarge?.copyWith(color: AppColors.onDark),
                ),
        ),
      ),
    );
  }

  Widget _buildCodeDisplay(AppSpacing spacing, TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: spacing.xl),
        Text(
          'הקוד שלך',
          style: text.titleMedium?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spacing.lg),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: spacing.xxl,
            horizontal: spacing.xl,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Text(
            _generatedCode!,
            style: text.displayLarge?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w800,
              letterSpacing: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: spacing.lg),
        OutlinedButton.icon(
          onPressed: _copyCode,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: const Icon(Icons.copy, color: AppColors.primary),
          label: Text(
            'העתק קוד',
            style: text.labelLarge?.copyWith(color: AppColors.primary),
          ),
        ),
        SizedBox(height: spacing.xl),
        Text(
          'שלח את הקוד לבן/בת הזוג שלך.\nהם יכנסו לאפליקציה ויזינו אותו.',
          style: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spacing.xl),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: () {
              ref
                ..invalidate(profileExistsProvider)
                ..invalidate(isCoupleLinkedProvider);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: const StadiumBorder(),
            ),
            child: Text(
              'המשך לאפליקציה ←',
              style: text.labelLarge?.copyWith(color: AppColors.onDark),
            ),
          ),
        ),
        SizedBox(height: spacing.md),
        Text(
          'הפרטנר יכול להצטרף גם מאוחר יותר',
          style: text.bodySmall?.copyWith(color: AppColors.textDisabled),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.spacing,
    required this.text,
    this.isLoading = false,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isLoading;
  final AppSpacing spacing;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            SizedBox(width: spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: text.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: text.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              const Icon(Icons.chevron_left, color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }
}
