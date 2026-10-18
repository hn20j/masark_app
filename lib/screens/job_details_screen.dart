import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool _applying = false;
  bool _applied = false;

  Future<void> _applyWithAgent() async {
    setState(() => _applying = true);
    await Future.delayed(
        const Duration(milliseconds: 900)); // simulate agent submitting the CV
    if (!mounted) return;
    setState(() {
      _applying = false;
      _applied = true;
    });
    DemoData.applications.insert(
      0,
      Application(
        id: 'a${DemoData.applications.length + 1}',
        job: widget.job,
        status: ApplicationStatus.submitted,
        submittedAt: DateTime.now(),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceIndigoLight,
        behavior: SnackBarBehavior.floating,
        content: Text(
          AppText.of(context, 'تم تقديم طلبك إلى ${widget.job.company} بنجاح ✓',
              'Your application to ${widget.job.company} was submitted ✓'),
          textAlign: TextAlign.start,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          title: Text(AppText.of(context, 'تفاصيل الوظيفة', 'Job details'))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt,
                                  size: 13, color: AppColors.success),
                              const SizedBox(width: 3),
                              Text(
                                  AppText.of(
                                      context,
                                      '${job.matchScore}% تطابق مع سيرتك',
                                      '${job.matchScore}% match for your CV'),
                                  style: const TextStyle(
                                      color: AppColors.success,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(AppText.content(context, job.title),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(AppText.content(context, job.company),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: [
                  _infoChip(Icons.location_on_outlined,
                      AppText.content(context, job.location)),
                  _infoChip(
                      Icons.work_outline, AppText.content(context, job.type)),
                  _infoChip(Icons.attach_money, job.salaryRange),
                ],
              ),
              const SizedBox(height: 22),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(AppText.of(context, 'عن الوظيفة', 'About the role'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 10),
              Text(
                AppText.of(
                    context,
                    'نبحث عن مرشح متحمس للانضمام إلى فريقنا للمساهمة في تطوير منتجات رقمية عالية الجودة. '
                        'ستعمل ضمن فريق متعدد التخصصات وتساهم في اتخاذ قرارات تقنية مهمة.',
                    'We are looking for a motivated candidate to help build high-quality digital products. You will work with a cross-functional team and contribute to important technical decisions.'),
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.5,
                    height: 1.7),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                    AppText.of(context, 'المهارات المطلوبة', 'Required skills'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 8,
                children: job.tags
                    .map((t) => Chip(
                          label: Text(t),
                          backgroundColor: AppColors.surfaceIndigoLight,
                          labelStyle: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadii.pill),
                              side: BorderSide.none),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 26),
              Container(
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
                        const Icon(Icons.smart_toy_outlined,
                            color: AppColors.primaryVioletDark),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppText.of(
                                context,
                                'سيقوم الوكيل الذكي بتخصيص سيرتك الذاتية ورسالة التقديم تلقائيًا لهذه الوظيفة',
                                'The AI agent will tailor your CV and application message for this job.'),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: AppColors.textDark,
                                fontSize: 12.5,
                                height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _applied
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: AppColors.success, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                  AppText.of(context, 'تم التقديم بنجاح',
                                      'Application submitted'),
                                  style: const TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w700)),
                            ],
                          )
                        : PinkButton(
                            label: _applying
                                ? AppText.of(context, 'الوكيل يقدم طلبك...',
                                    'Agent is applying...')
                                : AppText.of(
                                    context, 'قدّم عني الآن', 'Apply for me'),
                            icon: Icons.send_outlined,
                            onPressed: _applying ? null : _applyWithAgent,
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

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceIndigoLight,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          const SizedBox(width: 6),
          Icon(icon, size: 14, color: AppColors.accentPink),
        ],
      ),
    );
  }
}
