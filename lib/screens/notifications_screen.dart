import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotificationItem(
        title: AppText.of(
            context, 'تم تحديث حالة طلبك', 'Application status updated'),
        subtitle: AppText.of(
            context,
            'تمت مراجعة ملفك الشخصي من قبل الفريق وسيتم تقديمه قريباً.',
            'Your profile has been reviewed and will be submitted soon.'),
        time: AppText.of(context, 'منذ 5 دقائق', '5 minutes ago'),
        color: AppColors.success,
        icon: Icons.check_circle_outline,
      ),
      _NotificationItem(
        title: AppText.of(context, 'مقابلة جديدة', 'New interview'),
        subtitle: AppText.of(
            context,
            'تم تحديد موعد مقابلة مع شركة لاندستار خلال اليوم التالي.',
            'An interview with Landstar has been scheduled for tomorrow.'),
        time: AppText.of(context, 'منذ 1 ساعة', '1 hour ago'),
        color: AppColors.warning,
        icon: Icons.event_available_outlined,
      ),
      _NotificationItem(
        title: AppText.of(context, 'فرصة مناسبة لك', 'A job match for you'),
        subtitle: AppText.of(
            context,
            'تم العثور على وظيفة جديدة في مجال التصميم وتجربة المستخدم.',
            'A new job in design and user experience was found.'),
        time: AppText.of(context, 'اليوم', 'Today'),
        color: AppColors.primaryViolet,
        icon: Icons.work_outline,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppText.of(context, 'الإشعارات', 'Notifications')),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            item.time,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final IconData icon;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}
