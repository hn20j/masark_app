import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../theme/app_state.dart';
import '../models/models.dart';
import '../widgets/entrance_animation.dart';
import '../widgets/job_card.dart';
import 'cv_upload_screen.dart';
import 'job_listings_screen.dart';
import 'job_details_screen.dart';
import 'applications_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';

/// Bottom-nav shell that hosts Home / Jobs / Applications / Profile.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  late final List<Widget> _pages = [
    _HomeDashboard(onNavigateTo: (index) => setState(() => _navIndex = index)),
    const JobListingsScreen(embedded: true),
    const ApplicationsScreen(embedded: true),
    const ProfileScreen(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final position = Tween<Offset>(
              begin: const Offset(0, 0.025),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: position, child: child),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(_navIndex),
            child: _pages[_navIndex],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              label: AppText.of(context, 'الرئيسية', 'Home')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: AppText.of(context, 'الفرص', 'Jobs')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.send_outlined),
              label: AppText.of(context, 'طلباتي', 'Applications')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              label: AppText.of(context, 'حسابي', 'Profile')),
        ],
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  final void Function(int index) onNavigateTo;

  const _HomeDashboard({required this.onNavigateTo});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final applications = DemoData.applications;
    final topJobs = DemoData.jobs.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EntranceAnimation(
            delay: const Duration(milliseconds: 40),
            child: Row(
              children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surfaceIndigoLight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const NotificationsScreen()),
                  ),
                  icon: const Icon(Icons.notifications_none,
                      color: Colors.white, size: 20),
                  padding: EdgeInsets.zero,
                  splashRadius: 18,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${AppText.of(context, 'مرحبا', 'Hello')}${user != null ? ' ${user.name}' : ''}!',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  Text(AppText.of(context, 'لوحة التحكم', 'Dashboard'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Hero card — mirrors wireframe 4's greeting + upload CTA card.
          EntranceAnimation(
            delay: const Duration(milliseconds: 100),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: '${AppText.of(context, 'مرحبا', 'Hello')}\n',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15),
                      children: [
                        TextSpan(
                          text:
                              '${user?.name ?? AppText.of(context, 'بك', 'there')}!',
                          style: const TextStyle(
                              color: AppColors.accentPink,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppText.of(
                        context,
                        'ارفع سيرتك الذاتية\nودع الذكاء الاصطناعي\nيقدم عنك',
                        'Upload your CV\nLet AI\napply for you'),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                      AppText.of(
                          context, 'يقدم عنك...', 'Applying for you...'),
                      style: const TextStyle(
                          color: AppColors.accentPink, fontSize: 12)),
                  const SizedBox(height: 16),
                  if (user?.cvFileName == null)
                    SizedBox(
                      width: double.infinity,
                      child: PinkButton(
                        label: AppText.of(
                            context, 'ابدأ الآن', 'Get started'),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const CvUploadScreen()),
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.success, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(user!.cvFileName!,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  OutlineButton(
                    label: AppText.of(context, 'تصفح الفرص', 'Browse jobs'),
                    trailingIcon: Icons.arrow_back,
                    onPressed: () => onNavigateTo(1),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          if (user?.profileCompletion != null && user!.profileCompletion < 1.0)
            EntranceAnimation(
              delay: const Duration(milliseconds: 180),
              child: _ProfileCompletionCard(user: user),
            ),
          const SizedBox(height: 22),
          EntranceAnimation(
            delay: const Duration(milliseconds: 180),
            child: _SectionHeader(
              title: AppText.of(
                  context, 'نشاط الوكيل الذكي', 'AI agent activity'),
              actionLabel: AppText.of(context, 'عرض الكل', 'View all'),
              onAction: () => onNavigateTo(2),
            ),
          ),
          const SizedBox(height: 12),
          ...applications.take(2).map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EntranceAnimation(
                  delay: const Duration(milliseconds: 240),
                  child: _AgentActivityTile(application: a),
                ),
              )),
          const SizedBox(height: 22),
          EntranceAnimation(
            delay: const Duration(milliseconds: 320),
            child: _SectionHeader(
              title: AppText.of(context, 'فرص تناسبك', 'Recommended for you'),
              actionLabel: AppText.of(context, 'عرض الكل', 'View all'),
              onAction: () => onNavigateTo(1),
            ),
          ),
          const SizedBox(height: 12),
          ...topJobs.map((j) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EntranceAnimation(
                  delay: const Duration(milliseconds: 380),
                  child: JobCard(
                    job: j,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => JobDetailsScreen(job: j)),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _ProfileCompletionCard extends StatelessWidget {
  final AppUser user;
  const _ProfileCompletionCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final pct = (user.profileCompletion * 100).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceIndigoLight,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.accentPink.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('$pct%',
                  style: const TextStyle(
                      color: AppColors.accentPink,
                      fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(
                  AppText.of(
                      context, 'اكتمال الملف الشخصي', 'Profile completion'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: user.profileCompletion,
              minHeight: 7,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation(AppColors.accentPink),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              AppText.of(context, 'أكمل ملفك ليتمكن الوكيل من التقديم بشكل أدق',
                  'Complete your profile so the agent can apply more accurately.'),
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  const _SectionHeader(
      {required this.title, required this.actionLabel, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(onPressed: onAction, child: Text(actionLabel)),
        const Spacer(),
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _AgentActivityTile extends StatelessWidget {
  final Application application;
  const _AgentActivityTile({required this.application});

  @override
  Widget build(BuildContext context) {
    final status = statusMeta(context, application.status);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: status.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadii.pill)),
            child: Text(status.label,
                style: TextStyle(
                    color: status.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
          const Spacer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.content(context, application.job.title),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                Text(AppText.content(context, application.job.company),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 11.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusMeta {
  final String label;
  final Color color;
  const StatusMeta(this.label, this.color);
}

StatusMeta statusMeta(BuildContext context, ApplicationStatus status) {
  switch (status) {
    case ApplicationStatus.queued:
      return StatusMeta(
          AppText.of(context, 'قيد التجهيز', 'Queued'), AppColors.textMuted);
    case ApplicationStatus.submitted:
      return StatusMeta(AppText.of(context, 'تم الإرسال', 'Submitted'),
          AppColors.primaryVioletDark);
    case ApplicationStatus.viewed:
      return StatusMeta(
          AppText.of(context, 'تمت المشاهدة', 'Viewed'), AppColors.warning);
    case ApplicationStatus.interview:
      return StatusMeta(
          AppText.of(context, 'مقابلة', 'Interview'), AppColors.success);
    case ApplicationStatus.rejected:
      return StatusMeta(
          AppText.of(context, 'مرفوض', 'Rejected'), AppColors.error);
    case ApplicationStatus.offer:
      return StatusMeta(
          AppText.of(context, 'عرض عمل', 'Offer'), AppColors.success);
  }
}
