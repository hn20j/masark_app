import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central color & style tokens for the Masarak (مسارك) app.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0D1849);
  static const Color surfaceIndigo = Color(0xFF101E4D);
  static const Color surfaceIndigoLight = Color(0xFF162952);

  static const Color primaryViolet = Color(0xFF5EEFFF);
  static const Color primaryVioletDark = Color(0xFF0D1849);

  static const Color accentPink = Color(0xFF5EEFFF);
  static const Color accentPinkDark = Color(0xFF00A8C4);

  static const Color cardLight = Color(0xFFF6F6F6);
  static const Color inputFill = Color(0xFFF6F6F6);

  static const Color black = Color(0xFF000000);
  static const Color textPrimary = Color(0xFFF6F6F6);
  static const Color textSecondary = Color(0xFFC4D4E8);
  static const Color textDark = black;
  static const Color textMuted = Color(0xFF64779F);

  static const Color success = Color(0xFF3ED598);
  static const Color warning = Color(0xFFFFC24B);
  static const Color error = Color(0xFFFF5B6E);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D1849), Color(0xFF162952)],
  );

  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF5EEFFF), Color(0xFFF6F6F6)],
  );
}

class AppRadii {
  AppRadii._();
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double pill = 100;
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.cairoTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryViolet,
      textTheme: textTheme,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primaryViolet,
        onPrimary: AppColors.surfaceIndigo,
        secondary: AppColors.accentPink,
        onSecondary: AppColors.surfaceIndigo,
        surface: AppColors.surfaceIndigo,
        error: AppColors.error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: GoogleFonts.cairo(color: AppColors.textMuted, fontSize: 14),
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
          backgroundColor: AppColors.cardLight,
          foregroundColor: AppColors.textDark,
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
          foregroundColor: AppColors.textSecondary,
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
        backgroundColor: AppColors.surfaceIndigo,
        selectedItemColor: AppColors.accentPink,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle:
            GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.cairo(fontSize: 11),
      ),
    );
  }
}

/// Reusable primary CTA button with a cyan outline used across the app.
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
          backgroundColor: AppColors.surfaceIndigo,
          foregroundColor: Colors.white,
          side: const BorderSide(color: AppColors.accentPink, width: 1.4),
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

/// Hero CTA button, used for the primary "Upload CV" action.
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
          boxShadow: const [
            BoxShadow(
                color: Color(0x555EEFFF), blurRadius: 18, offset: Offset(0, 8)),
          ],
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
                  Icon(icon, size: 18, color: AppColors.black),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: GoogleFonts.cairo(
                    color: AppColors.black,
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
          foregroundColor: Colors.white,
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
