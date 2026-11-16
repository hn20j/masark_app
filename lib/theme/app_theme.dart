import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central color & style tokens for the Masarak (مسارك) app.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF111116);
  static const Color surfaceIndigo = Color(0xFF19191F);
  static const Color surfaceIndigoLight = Color(0xFF25252E);

  static const Color primaryViolet = Color(0xFF8B5CF6);
  static const Color primaryVioletDark = Color(0xFF6D3DD1);

  static const Color accentPink = Color(0xFF8B5CF6);
  static const Color accentPinkDark = Color(0xFF6D3DD1);
  static const Color accentYellow = Color(0xFFFFD166);

  static const Color cardLight = Color(0xFFF8F7FA);
  static const Color inputFill = Color(0xFFF2F0F6);

  static const Color black = Color(0xFF000000);
  static const Color textPrimary = Color(0xFFF7F5FA);
  static const Color textSecondary = Color(0xFFC5C1CF);
  static const Color textDark = Color(0xFF1D1A24);
  static const Color textMuted = Color(0xFF777180);

  static const Color success = Color(0xFF249C70);
  static const Color warning = Color(0xFFE0A62E);
  static const Color error = Color(0xFFD94B5B);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF19191F), Color(0xFF252330)],
  );

  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF7048D1)],
  );
}

class AppRadii {
  AppRadii._();
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double pill = 100;
}

class AppSpacing {
  AppSpacing._();
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color surfaceIndigo;
  final Color surfaceIndigoLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color outline;
  final LinearGradient heroGradient;

  const AppPalette({
    required this.background,
    required this.surfaceIndigo,
    required this.surfaceIndigoLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.outline,
    required this.heroGradient,
  });

  @override
  AppPalette copyWith({
    Color? background,
    Color? surfaceIndigo,
    Color? surfaceIndigoLight,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? outline,
    LinearGradient? heroGradient,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surfaceIndigo: surfaceIndigo ?? this.surfaceIndigo,
      surfaceIndigoLight: surfaceIndigoLight ?? this.surfaceIndigoLight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      outline: outline ?? this.outline,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surfaceIndigo: Color.lerp(surfaceIndigo, other.surfaceIndigo, t)!,
      surfaceIndigoLight:
          Color.lerp(surfaceIndigoLight, other.surfaceIndigoLight, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get appPalette => Theme.of(this).extension<AppPalette>()!;
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);
  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final palette = AppPalette(
      background: isDark ? const Color(0xFF111116) : const Color(0xFFF6F5F8),
      surfaceIndigo: isDark ? const Color(0xFF19191F) : const Color(0xFFFFFFFF),
      surfaceIndigoLight:
          isDark ? const Color(0xFF25252E) : const Color(0xFFEDEAF3),
      textPrimary: isDark ? const Color(0xFFF7F5FA) : const Color(0xFF211E28),
      textSecondary: isDark ? const Color(0xFFC5C1CF) : const Color(0xFF625D6B),
      textMuted: isDark ? const Color(0xFFAAA5B2) : const Color(0xFF777180),
      outline: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : const Color(0xFF241E30).withValues(alpha: 0.1),
      heroGradient: isDark
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF19191F), Color(0xFF252330)],
            )
          : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFECE5FC), Color(0xFFF8F6FC)],
            ),
    );
    final base = isDark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme)
        .apply(
          bodyColor: palette.textPrimary,
          displayColor: palette.textPrimary,
        )
        .copyWith(
          headlineLarge: GoogleFonts.cairo(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
          ),
          headlineMedium: GoogleFonts.cairo(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
          ),
          titleLarge: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
          titleMedium: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        );

    return base.copyWith(
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      primaryColor: AppColors.primaryViolet,
      textTheme: textTheme,
      extensions: [palette],
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        primary: AppColors.primaryViolet,
        onPrimary: Colors.white,
        secondary: AppColors.accentYellow,
        onSecondary: AppColors.textDark,
        surface: palette.surfaceIndigo,
        onSurface: palette.textPrimary,
        error: AppColors.error,
      ),
      dividerColor: palette.outline,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: GoogleFonts.cairo(color: AppColors.textMuted, fontSize: 14),
        labelStyle: GoogleFonts.cairo(color: AppColors.textMuted, fontSize: 13),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide:
              const BorderSide(color: AppColors.primaryViolet, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryViolet,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          textStyle:
              GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor:
              isDark ? AppColors.primaryViolet : AppColors.primaryVioletDark,
          textStyle:
              GoogleFonts.cairo(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surfaceIndigo,
        selectedItemColor: AppColors.primaryViolet,
        unselectedItemColor: palette.textSecondary.withValues(alpha: 0.8),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle:
            GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.cairo(fontSize: 11),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceIndigo,
        titleTextStyle: GoogleFonts.cairo(
          color: palette.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: GoogleFonts.cairo(color: palette.textSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    );
  }
}

/// Reusable pill-shaped primary action.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryViolet,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
        ),
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.4, color: Colors.white),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

/// Prominent CTA button, used for the primary "Upload CV" action.
class PinkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PinkButton(
      {super.key, required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.pinkGradient,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary outline button (used for "تصفح الفرص" style actions).
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;

  const OutlineButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppColors.textDark,
          side: const BorderSide(color: AppColors.primaryViolet, width: 1.4),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.pill)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            if (trailingIcon != null) ...[
              const SizedBox(width: 6),
              Icon(trailingIcon, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
