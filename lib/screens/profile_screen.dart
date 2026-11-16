import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../theme/app_state.dart';
import '../widgets/language_selector.dart';
import 'cv_upload_screen.dart';
import 'cv_builder_screen.dart';
import 'onboarding_screen.dart';
import 'notifications_screen.dart';
import 'account_edit_screen.dart';
import '../widgets/theme_mode_selector.dart';

class ProfileScreen extends StatelessWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;

    final content = SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(AppText.of(context, 'حسابي', 'Profile'),
                style: TextStyle(
                    color: context.appPalette.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: context.appPalette.heroGradient,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const AccountEditScreen()),
                  ),
                  icon: Icon(Icons.edit_outlined,
                      color: context.appPalette.textSecondary, size: 18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? AppText.of(context, 'زائر', 'Guest'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: context.appPalette.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user?.email ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: context.appPalette.textSecondary,
                            fontSize: 12.5),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user?.homeCountry ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.accentPink, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.location_on_outlined,
                              size: 13, color: AppColors.accentPink),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: context.appPalette.surfaceIndigoLight,
                  child: Text(
                    (user != null && user.name.isNotEmpty)
                        ? user.name.substring(0, 1)
                        : '؟',
                    style: TextStyle(
                        color: context.appPalette.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _SectionCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.of(context, 'لغة التطبيق', 'App language'),
                        style: const TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5)),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: LanguageSelector(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppText.of(context, 'مظهر التطبيق', 'App appearance'),
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const ThemeModeSelector(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            children: [
              _ProfileTile(
                icon: Icons.manage_accounts_outlined,
                title:
                    AppText.of(context, 'إعدادات الحساب', 'Account settings'),
                subtitle: AppText.of(
                    context,
                    'تعديل الاسم والبريد وكلمة المرور',
                    'Edit name, email, and password'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AccountEditScreen()),
                ),
              ),
              _ProfileTile(
                icon: Icons.description_outlined,
                title: AppText.of(context, 'سيرتي الذاتية', 'My CV'),
                subtitle: user?.cvFileName ??
                    AppText.of(context, 'لم يتم الرفع بعد', 'Not uploaded yet'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CvUploadScreen()),
                ),
              ),
              _ProfileTile(
                icon: Icons.badge_outlined,
                title: AppText.of(
                    context, 'تفضيلات التقديم', 'Application preferences'),
                subtitle: AppText.of(
                    context,
                    'المجال والتخصص، الوظائف والمهارات، العراق',
                    'Field, major, roles, skills, Iraq'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CvBuilderScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            children: [
              _ProfileTile(
                icon: Icons.notifications_none,
                title: AppText.of(context, 'الإشعارات', 'Notifications'),
                subtitle: AppText.of(context, 'تنبيهات عند تحديث حالة طلب',
                    'Alerts when an application status changes'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen()),
                ),
              ),
              _ProfileTile(
                icon: Icons.notifications_active_outlined,
                title: AppText.of(
                    context, 'تفعيل الإشعارات', 'Enable push notifications'),
                subtitle: AppText.of(
                  context,
                  'تتطلب ربط مزود إشعارات',
                  'Connect a notification provider to enable',
                ),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppText.of(
                      context,
                      'الإشعارات غير متاحة حتى إعداد مزود إشعارات.',
                      'Notifications are unavailable until a provider is configured.',
                    )),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionCard(
            children: [
              _ProfileTile(
                  icon: Icons.help_outline,
                  title: AppText.of(context, 'مركز المساعدة', 'Help center'),
                  onTap: () {}),
              _ProfileTile(
                  icon: Icons.privacy_tip_outlined,
                  title: AppText.of(
                      context, 'الخصوصية والأمان', 'Privacy and security'),
                  onTap: () {}),
              _ProfileTile(
                icon: Icons.logout,
                title: AppText.of(context, 'تسجيل الخروج', 'Sign out'),
                titleColor: AppColors.error,
                onTap: () async {
                  await context.read<AppState>().signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );

    if (embedded) return content;
    return Scaffold(
        backgroundColor: context.appPalette.background,
        body: SafeArea(child: content));
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.chevron_left, color: AppColors.textMuted),
      trailing: Icon(icon, color: titleColor ?? AppColors.primaryVioletDark),
      title: Text(title,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: titleColor ?? AppColors.textDark,
              fontWeight: FontWeight.w700,
              fontSize: 13.5)),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!,
              textAlign: TextAlign.start,
              style:
                  const TextStyle(color: AppColors.textMuted, fontSize: 11.5)),
    );
  }
}
