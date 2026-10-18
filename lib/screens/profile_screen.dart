import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const AccountEditScreen()),
                  ),
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.textSecondary, size: 18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? AppText.of(context, 'زائر', 'Guest'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user?.email ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12.5),
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
                  backgroundColor: AppColors.surfaceIndigoLight,
                  child: Text(
                    (user != null && user.name.isNotEmpty)
                        ? user.name.substring(0, 1)
                        : '؟',
                    style: const TextStyle(
                        color: Colors.white,
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
              _ProfileSwitchTile(
                icon: Icons.smart_toy_outlined,
                title: AppText.of(context, 'التقديم التلقائي بالوكيل',
                    'Automatic applications'),
                subtitle: AppText.of(
                    context,
                    'يسمح للوكيل بالتقديم دون مراجعتك لكل طلب',
                    'Let the agent apply without reviewing each application'),
                value: state.agentAutoApplyEnabled,
                onChanged: (v) =>
                    context.read<AppState>().toggleAgentAutoApply(v),
              ),
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
                subtitle: state.pushToken == null
                    ? AppText.of(context, 'تفعيل الإشعارات على هذا الجهاز',
                        'Allow notifications on this device')
                    : AppText.of(context, 'الإشعارات مفعّلة على هذا الجهاز',
                        'Notifications are enabled on this device'),
                onTap: () async {
                  try {
                    final token = await context
                        .read<AppState>()
                        .enablePushNotifications();
                    if (!context.mounted) return;
                    if (token == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppText.of(
                            context,
                            'لم يتم منح إذن الإشعارات.',
                            'Notification permission was not granted.',
                          )),
                        ),
                      );
                      return;
                    }

                    await showDialog<void>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: Text(AppText.of(
                          context,
                          'رمز جهاز الإشعارات',
                          'Device notification token',
                        )),
                        content: SelectableText(token),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text(AppText.of(
                              context,
                              'إغلاق',
                              'Close',
                            )),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: token));
                              if (!context.mounted) return;
                              Navigator.of(dialogContext).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppText.of(
                                    context,
                                    'تم نسخ الرمز.',
                                    'Token copied.',
                                  )),
                                ),
                              );
                            },
                            child: Text(AppText.of(
                              context,
                              'نسخ الرمز',
                              'Copy token',
                            )),
                          ),
                        ],
                      ),
                    );
                  } catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppText.of(
                          context,
                          'تعذر تفعيل الإشعارات: $error',
                          'Could not enable notifications: $error',
                        )),
                      ),
                    );
                  }
                },
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
        backgroundColor: AppColors.background, body: SafeArea(child: content));
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

class _ProfileSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.accentPink),
      trailing: Icon(icon, color: AppColors.primaryVioletDark),
      title: Text(title,
          textAlign: TextAlign.start,
          style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              fontSize: 13.5)),
      subtitle: Text(subtitle,
          textAlign: TextAlign.start,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5)),
    );
  }
}
