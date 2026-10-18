import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../widgets/entrance_animation.dart';
import '../widgets/language_selector.dart';
import 'signup_type_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingPage {
  final String title;
  final String body;
  final IconData icon;
  const _OnboardingPage(
      {required this.title, required this.body, required this.icon});
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  List<_OnboardingPage> _pages(BuildContext context) => [
        _OnboardingPage(
          title: AppText.of(
              context, 'مرحبا بك في تطبيق مسارك', 'Welcome to Masarak'),
          body: AppText.of(
            context,
            'ارفع سيرتك الذاتية، ودع الذكاء الاصطناعي يقدم عنك.\n\nمنصة مسارك الذكية تحلل سيرتك الذاتية، وتطابقك مع أفضل الفرص المتاحة من وظائف ومنح وتدريب، وتكتب رسائل تقديم مخصصة ومقنعة بضغطة واحدة.',
            'Upload your CV and let AI apply for you.\n\nMasarak analyzes your CV, matches you with jobs, scholarships, and training, then writes tailored applications in one tap.',
          ),
          icon: Icons.auto_awesome,
        ),
        _OnboardingPage(
          title: AppText.of(context, 'وكيلك الذكي يقدم بدلاً عنك',
              'Your AI agent applies for you'),
          body: AppText.of(
            context,
            'بعد رفع سيرتك، يقوم الوكيل الذكي تلقائيًا بالبحث عن الشركات المناسبة في بلدك وتقديم طلبك إليها، ويرسل لك تحديثًا بكل خطوة.',
            'After you upload your CV, the AI agent finds suitable companies in your country, submits applications, and keeps you updated at every step.',
          ),
          icon: Icons.smart_toy_outlined,
        ),
        _OnboardingPage(
          title: AppText.of(context, 'تابع طلباتك في مكان واحد',
              'Track every application in one place'),
          body: AppText.of(
            context,
            'راقب حالة كل طلب تقديم — من الإرسال حتى المقابلة — من خلال لوحة متابعة بسيطة وواضحة.',
            'Follow each application from submission to interview in one clear dashboard.',
          ),
          icon: Icons.track_changes_outlined,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final pages = _pages(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 8),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: LanguageSelector(),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _OnboardingCard(
                  key: ValueKey(i),
                  page: pages[i],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _index ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _index
                        ? AppColors.accentPink
                        : AppColors.textMuted,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: PrimaryButton(
                label: _index == pages.length - 1
                    ? AppText.of(context, 'ابدأ', 'Get started')
                    : AppText.of(context, 'التالي', 'Next'),
                onPressed: () {
                  if (_index == pages.length - 1) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const SignupTypeScreen(signInMode: true),
                      ),
                    );
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const SignupTypeScreen(signInMode: true),
                ),
              ),
              child: Text(AppText.of(context, 'تخطي', 'Skip')),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  final _OnboardingPage page;
  const _OnboardingCard({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return EntranceAnimation(
      offset: const Offset(0, 0.05),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.accentPink.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(page.icon, color: AppColors.accentPink, size: 26),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      page.title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      page.body,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 13, height: 1.6),
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
