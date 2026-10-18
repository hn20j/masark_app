import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_state.dart';
import '../theme/app_theme.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppState>().locale;
    return SegmentedButton<String>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(value: 'en', label: Text('English')),
        ButtonSegment(value: 'ar', label: Text('العربية')),
      ],
      selected: {locale.languageCode},
      onSelectionChanged: (selection) {
        context.read<AppState>().setLocale(Locale(selection.first));
      },
      style: SegmentedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        selectedForegroundColor: Colors.white,
        selectedBackgroundColor: AppColors.primaryVioletDark,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
