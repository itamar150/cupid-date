import 'package:cupid_date/core/data/israeli_cities.dart';
import 'package:cupid_date/core/theme/app_colors.dart';
import 'package:cupid_date/core/theme/app_spacing.dart';
import 'package:cupid_date/core/widgets/onboarding_header.dart';
import 'package:cupid_date/presentation/auth/providers/auth_providers.dart';
import 'package:cupid_date/presentation/onboarding/screens/hang_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String? _selectedArea;
  double _radius = 10;
  final Set<String> _foodPreferences = {};
  bool _surpriseOptIn = false;
  bool _isLoading = false;


  static const _foodOptions = [
    'כשר',
    'טבעוני',
    'ללא גלוטן',
    'הכל בסדר',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  String _normalize(String s) => s
      .replaceAll('-', ' ')
      .replaceAll('–', ' ')
      .replaceAll("'", '')
      .replaceAll('(', '')
      .replaceAll(')', '')
      .trim();

  bool get _isValid =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _selectedArea != null;

  Future<void> _submit() async {
    if (!_isValid) return;
    setState(() => _isLoading = true);
    try {
      final email = Supabase.instance.client.auth.currentUser?.email ?? '';
      await ref.read(createProfileProvider).call(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: email,
            area: _selectedArea!,
            maxRadius: _radius.round(),
            foodPreferences: _foodPreferences.toList(),
            surpriseOptIn: _surpriseOptIn,
          );
      if (mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const VibeProfileScreen(),
          ),
        );
      }
    } on Exception catch (e) {
      // Temporary debug — remove before release
      // ignore: avoid_print
      print('submit error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('שגיאה בשמירת הפרופיל. נסה שוב.')),
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
            title: 'קצת עלייך',
            subtitle: 'נגדיר את ההעדפות שלך',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                spacing.xxl,
                spacing.xl,
                spacing.xxl,
                100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _firstNameController,
                    label: 'שם פרטי',
                    hint: 'ישראל',
                    text: text,
                    spacing: spacing,
                  ),
                  SizedBox(height: spacing.lg),
                  _buildTextField(
                    controller: _lastNameController,
                    label: 'שם משפחה',
                    hint: 'ישראלי',
                    text: text,
                    spacing: spacing,
                  ),
                  SizedBox(height: spacing.lg),
                  _buildAreaDropdown(text, spacing),
                  SizedBox(height: spacing.xl),
                  _buildRadiusSlider(text, spacing),
                  SizedBox(height: spacing.xl),
                  _buildFoodChips(text, spacing),
                  SizedBox(height: spacing.xl),
                  _buildSurpriseToggle(text, spacing),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(text, spacing),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.red,
        onPressed: () => ref.read(signOutProvider).call(),
        child: const Icon(Icons.logout, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextTheme text,
    required AppSpacing spacing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: text.labelLarge?.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: spacing.xs),
        TextField(
          controller: controller,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
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

  Widget _buildAreaDropdown(TextTheme text, AppSpacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'עיר מגורים',
          style: text.labelLarge?.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: spacing.xs),
        Autocomplete<String>(
          initialValue: _selectedArea != null
              ? TextEditingValue(text: _selectedArea!)
              : null,
          optionsBuilder: (TextEditingValue value) {
            final query = _normalize(value.text);
            if (query.isEmpty) return const [];
            if (IsraeliCities.all.any((c) => _normalize(c) == query)) {
              return const [];
            }
            final matches = IsraeliCities.all
                .where((city) => _normalize(city).contains(query))
                .toList()
              ..sort((a, b) {
                final an = _normalize(a);
                final bn = _normalize(b);
                final aStarts = an.startsWith(query) ? 0 : 1;
                final bStarts = bn.startsWith(query) ? 0 : 1;
                if (aStarts != bStarts) return aStarts - bStarts;
                return an.compareTo(bn);
              });
            return matches;
          },
          onSelected: (city) => setState(() => _selectedArea = city),
          fieldViewBuilder: (context, controller, focusNode, onSubmit) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              textDirection: TextDirection.rtl,
              onChanged: (v) =>
                  setState(() => _selectedArea = v.isEmpty ? null : v),
              decoration: InputDecoration(
                hintText: 'הקלד שם עיר...',
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
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length > 5 ? 5 : options.length,
                itemBuilder: (context, i) {
                  final city = options.elementAt(i);
                  return ListTile(
                    dense: true,
                    title: Text(city, textDirection: TextDirection.rtl),
                    onTap: () => onSelected(city),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRadiusSlider(TextTheme text, AppSpacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'רדיוס מקסימלי',
              style: text.labelLarge?.copyWith(color: AppColors.textSecondary),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_radius.round()} ק"מ',
                style: text.labelMedium?.copyWith(
                  color: AppColors.onDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.primaryDark,
            inactiveTrackColor: AppColors.surfaceVariant,
            thumbColor: AppColors.primaryDark,
            overlayColor: AppColors.primaryDark.withValues(alpha: 0.12),
            trackHeight: 4,
          ),
          child: Slider(
            value: _radius,
            min: 1,
            max: 50,
            divisions: 49,
            onChanged: (v) => setState(() => _radius = v),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 ק"מ',
              style: text.bodySmall?.copyWith(color: AppColors.textDisabled),
            ),
            Text(
              '50 ק"מ',
              style: text.bodySmall?.copyWith(color: AppColors.textDisabled),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFoodChips(TextTheme text, AppSpacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'העדפות אוכל',
          style: text.labelLarge?.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: spacing.sm),
        Wrap(
          spacing: spacing.sm,
          runSpacing: spacing.sm,
          children: _foodOptions.map((option) {
            final selected = _foodPreferences.contains(option);
            return GestureDetector(
              onTap: () => setState(() {
                if (selected) {
                  _foodPreferences.remove(option);
                } else {
                  _foodPreferences.add(option);
                }
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.divider,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  option,
                  style: text.labelMedium?.copyWith(
                    color: selected ? Colors.white : AppColors.textSecondary,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSurpriseToggle(TextTheme text, AppSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'מצב הפתעה',
                  style: text.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  'תן לי לבחור בשבילכם ולהפתיע',
                  style: text.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _surpriseOptIn,
            onChanged: (v) => setState(() => _surpriseOptIn = v),
            activeThumbColor: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(TextTheme text, AppSpacing spacing) {
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
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: _isValid && !_isLoading ? AppColors.buttonGradient : null,
            color: _isValid && !_isLoading ? null : AppColors.textDisabled,
            borderRadius: BorderRadius.circular(999),
            boxShadow: _isValid && !_isLoading
                ? [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: FilledButton(
            onPressed: _isValid && !_isLoading ? _submit : null,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
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
                    'המשך ←',
                    style: text.labelLarge?.copyWith(
                      color: AppColors.onDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
