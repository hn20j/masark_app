import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../theme/app_state.dart';
import 'home_screen.dart' show statusMeta;
import 'job_details_screen.dart';
import 'package:provider/provider.dart';

class ApplicationsScreen extends StatefulWidget {
  final bool embedded;
  const ApplicationsScreen({super.key, this.embedded = false});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final applications = state.applications;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppText.of(context, 'طلباتي', 'My applications'),
                  style: TextStyle(
                      color: context.appPalette.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(
                  AppText.of(
                      context,
                      '${applications.length} طلب محفوظ داخل مسارك',
                      '${applications.length} application requests saved in Masarak'),
                  style: TextStyle(
                      color: context.appPalette.textSecondary, fontSize: 12.5)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: state.applicationsLoading
              ? const Center(child: CircularProgressIndicator())
              : state.applicationsError != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          state.applicationsError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    )
                  : applications.isEmpty
                      ? Center(
                          child: Text(
                              AppText.of(context, 'لا توجد طلبات بعد',
                                  'No applications yet'),
                              style:
                                  const TextStyle(color: AppColors.textMuted)),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: applications.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) =>
                              _ApplicationTile(application: applications[i]),
                        ),
        ),
      ],
    );

    if (widget.embedded) return content;
    return Scaffold(
        backgroundColor: context.appPalette.background,
        body: SafeArea(child: content));
  }
}

class _ApplicationTile extends StatelessWidget {
  final Application application;
  const _ApplicationTile({required this.application});

  @override
  Widget build(BuildContext context) {
    final status = statusMeta(context, application.status);
    final daysAgo = DateTime.now().difference(application.submittedAt).inDays;
    final agoLabel = daysAgo == 0
        ? AppText.of(context, 'اليوم', 'Today')
        : AppText.of(context, 'منذ $daysAgo يوم', '$daysAgo days ago');

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => JobDetailsScreen(job: application.job)),
      ),
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: status.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Text(status.label,
                      style: TextStyle(
                          color: status.color,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                Text(agoLabel,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 10),
            Text(AppText.content(context, application.job.title),
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5)),
            const SizedBox(height: 3),
            Text(AppText.content(context, application.job.company),
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12.5)),
            const SizedBox(height: 10),
            _StatusTimeline(current: application.status),
          ],
        ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final ApplicationStatus current;
  const _StatusTimeline({required this.current});

  static const _order = [
    ApplicationStatus.submitted,
    ApplicationStatus.viewed,
    ApplicationStatus.interview,
    ApplicationStatus.offer,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _order.indexOf(current);
    return Row(
      children: List.generate(_order.length, (i) {
        final reached =
            current == ApplicationStatus.rejected ? i == 0 : i <= currentIndex;
        return Expanded(
          child: Container(
            height: 4,
            margin:
                EdgeInsetsDirectional.only(end: i == _order.length - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color:
                  reached ? AppColors.primaryVioletDark : AppColors.inputFill,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
