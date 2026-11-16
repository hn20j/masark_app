import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_state.dart';
import '../theme/app_theme.dart';
import '../l10n/app_text.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<AppState>().themeMode;
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<ThemeMode>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: ThemeMode.light,
            label: Text(AppText.of(context, 'فاتح', 'Light')),
            icon: const Icon(Icons.light_mode_outlined),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            label: Text(AppText.of(context, 'داكن', 'Dark')),
            icon: const Icon(Icons.dark_mode_outlined),
          ),
        ],
        selected: {mode},
        onSelectionChanged: (selection) =>
            context.read<AppState>().setThemeMode(selection.first),
        style: SegmentedButton.styleFrom(
          foregroundColor: context.appPalette.textMuted,
          selectedForegroundColor: Colors.white,
          selectedBackgroundColor: AppColors.primaryViolet,
        ),
      ),
    );
  }
}
