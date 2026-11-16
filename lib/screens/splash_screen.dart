import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../theme/app_state.dart';
import '../widgets/entrance_animation.dart';
import '../widgets/language_selector.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import 'company_dashboard_screen.dart';
import 'signup_type_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _logoScale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
    _timer = Timer(const Duration(milliseconds: 1400), _openNextScreen);
  }

  Future<void> _openNextScreen() async {
    final state = context.read<AppState>();
    await state.initialize();
    final hasAccountProfile = await state.restoreProfileDetails(
      createIfMissing: false,
    );
    if (!mounted) return;
    final user = state.currentUser;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) {
          if (user == null) return const OnboardingScreen();
          if (!hasAccountProfile) {
            return const SignupTypeScreen(signInMode: true);
          }
          if (user.accountType == 'company') {
            return CompanyDashboardScreen(
              companyName: user.name,
              email: user.companyContactEmail ?? user.email,
              phone: user.phone ?? '',
              responsiblePerson: user.responsiblePerson ?? '',
              governorate: user.governorate ?? '',
            );
          }
          return const HomeScreen();
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.appPalette.heroGradient),
        child: SafeArea(
          child: Stack(
            children: [
              const PositionedDirectional(
                top: 12,
                end: 16,
                child: LanguageSelector(),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _logoScale,
                      child: EntranceAnimation(
                        duration: const Duration(milliseconds: 700),
                        offset: const Offset(0, 0.12),
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: AppColors.pinkGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.primaryViolet
                                      .withValues(alpha: 0.28),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10)),
                            ],
                          ),
                          child: const Icon(Icons.auto_awesome,
                              color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    EntranceAnimation(
                      delay: const Duration(milliseconds: 120),
                      child: Text(
                        'مسارك',
                        style: TextStyle(
                          color: context.appPalette.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    EntranceAnimation(
                      delay: const Duration(milliseconds: 240),
                      child: Text(
                        AppText.of(context, 'مسارك للتوظيف بالذكاء الاصطناعي',
                            'AI-powered career guidance'),
                        style: TextStyle(
                            color: context.appPalette.textSecondary,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
