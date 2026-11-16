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
            'ارفع سيرتك الذاتية، وتابع فرص العمل وطلباتك من مكان واحد.',
            'Upload your CV and manage job opportunities and application requests in one place.',
          ),
          icon: Icons.auto_awesome,
        ),
        _OnboardingPage(
          title: AppText.of(context, 'اطلب المساعدة بالتقديم',
              'Request application assistance'),
          body: AppText.of(
            context,
            'يمكنك حفظ طلب لمتابعته لاحقًا. لا تُرسل الطلبات إلى الشركات تلقائيًا.',
            'Save a request to follow up later. Requests are not automatically sent to companies.',
          ),
          icon: Icons.smart_toy_outlined,
        ),
        _OnboardingPage(
          title: AppText.of(context, 'تابع طلباتك في مكان واحد',
              'Track every application in one place'),
          body: AppText.of(
            context,
            'تابع الطلبات المحفوظة وأي تحديثات تصل إلى حسابك.',
            'Track saved requests and any updates added to your account.',
          ),
          icon: Icons.track_changes_outlined,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final pages = _pages(context);
    return Scaffold(
      backgroundColor: context.appPalette.background,
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
                        builder: (_) =>
                            const SignupTypeScreen(signInMode: true),
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
            gradient: context.appPalette.heroGradient,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: context.appPalette.outline),
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
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      page.body,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          height: 1.6),
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
