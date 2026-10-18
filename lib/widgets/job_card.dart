import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  final VoidCallback? onApply;

  const JobCard({super.key, required this.job, this.onTap, this.onApply});

  Color get _matchColor {
    if (job.matchScore >= 85) return AppColors.success;
    if (job.matchScore >= 65) return AppColors.warning;
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        width: double.infinity,
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
                    color: _matchColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 13, color: _matchColor),
                      const SizedBox(width: 3),
                      Text('${job.matchScore}% تطابق',
                          style: TextStyle(
                              color: _matchColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceIndigo,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.business_outlined,
                      color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(AppText.content(context, job.title),
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(AppText.content(context, job.company),
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12.5)),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 12,
              runSpacing: 6,
              children: [
                _metaChip(Icons.location_on_outlined,
                    AppText.content(context, job.location)),
                _metaChip(
                    Icons.work_outline, AppText.content(context, job.type)),
                _metaChip(Icons.attach_money, job.salaryRange),
              ],
            ),
            if (onApply != null) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onApply,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryVioletDark,
                    side: const BorderSide(
                        color: AppColors.primaryVioletDark, width: 1.2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.pill)),
                  ),
                  child: const Text('اطلب من الوكيل التقديم'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metaChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5)),
        const SizedBox(width: 3),
        Icon(icon, size: 13, color: AppColors.textMuted),
      ],
    );
  }
}
