import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
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
  bool _profileLoadFailed = false;
  String? _profileLoadErrorCode;
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
    var hasAccountProfile = true;
    try {
      await state.authReady;
      hasAccountProfile = await state.restoreProfileDetails(
        createIfMissing: false,
      );
    } on FirebaseException catch (error, stackTrace) {
      debugPrint(
        'Failed to restore Firestore account profile '
        '(${error.code}): ${error.message}',
      );
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _profileLoadFailed = true;
          _profileLoadErrorCode = error.code;
        });
      }
      return;
    }
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
    if (_profileLoadFailed) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _profileLoadErrorCode == 'permission-denied'
                        ? AppText.of(
                            context,
                            'رفض Firebase الوصول إلى بيانات الحساب. سجّل الخروج ثم ادخل مجددًا.',
                            'Firebase denied access to this account. Sign out and sign in again.',
                          )
                        : AppText.of(
                            context,
                            'تعذر تحميل بيانات الحساب من Firebase. تحقق من اتصالك وحاول مجددًا.',
                            'Could not load your Firebase account data. Check your connection and try again.',
                          ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  if (_profileLoadErrorCode != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Firebase error: $_profileLoadErrorCode',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: AppText.of(context, 'إعادة المحاولة', 'Retry'),
                    onPressed: () {
                      setState(() {
                        _profileLoadFailed = false;
                        _profileLoadErrorCode = null;
                      });
                      unawaited(_openNextScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
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
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0x555EEFFF),
                                  blurRadius: 30,
                                  offset: Offset(0, 10)),
                            ],
                          ),
                          child: const Icon(Icons.auto_awesome,
                              color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const EntranceAnimation(
                      delay: Duration(milliseconds: 120),
                      child: Text(
                        'مسارك',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 8),
                    EntranceAnimation(
                      delay: const Duration(milliseconds: 240),
                      child: Text(
                        AppText.of(context, 'مسارك للتوظيف بالذكاء الاصطناعي',
                            'AI-powered career guidance'),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
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
