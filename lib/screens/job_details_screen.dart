import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../theme/app_state.dart';
import 'package:provider/provider.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  String? _submittingMode;

  Future<void> _applyWithAgent() async {
    await _submitApplication(withAgent: true);
  }

  Future<void> _applyManually() async {
    final user = context.read<AppState>().currentUser;
    if (user == null || user.accountType != 'employee') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppText.of(
              context,
              'سجّل الدخول بحساب باحث عن عمل للتقديم.',
              'Sign in with a job seeker account to apply.',
            ),
          ),
        ),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.of(context, 'تقديم يدوي', 'Apply manually')),
        content: Text(
          AppText.of(
            context,
            'سيتم إرسال اسمك وبريدك الإلكتروني إلى الشركة مع طلب التقديم.',
            'Your name and email address will be sent to the company with your application.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppText.of(context, 'إلغاء', 'Cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppText.of(context, 'تقديم', 'Submit application')),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _submitApplication(withAgent: false);
    }
  }

  Future<void> _submitApplication({required bool withAgent}) async {
    setState(() => _submittingMode = withAgent ? 'agent' : 'manual');
    try {
      final state = context.read<AppState>();
      if (withAgent) {
        await state.requestApplication(widget.job);
      } else {
        await state.submitManualApplication(widget.job);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.appPalette.surfaceIndigoLight,
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppText.of(
              context,
              withAgent
                  ? 'تم حفظ طلب المساعدة في مسارك. لم يتم إرساله إلى الشركة.'
                  : 'تم إرسال طلب التقديم إلى الشركة.',
              withAgent
                  ? 'Your request was saved in Masarak. It has not been submitted to the company.'
                  : 'Your application was submitted to the company.',
            ),
            textAlign: TextAlign.start,
            style: TextStyle(color: context.appPalette.textPrimary),
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        final message = AppState.errorMessage(error);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            message.toLowerCase().contains('already exists') ||
                    message.toLowerCase().contains('already have')
                ? AppText.of(
                    context,
                    'لديك طلب تقديم محفوظ لهذه الوظيفة بالفعل.',
                    'You already have an application for this job.',
                  )
                : message,
          ),
        ));
      }
    } finally {
      if (mounted) setState(() => _submittingMode = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final state = context.watch<AppState>();
    final alreadyApplied =
        state.applications.any((application) => application.job.id == job.id);
    final isSubmitting = _submittingMode != null;
    return Scaffold(
      backgroundColor: context.appPalette.background,
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
                  gradient: context.appPalette.heroGradient,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (job.matchScore != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.18),
                              borderRadius:
                                  BorderRadius.circular(AppRadii.pill),
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
                        style: TextStyle(
                            color: context.appPalette.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(AppText.content(context, job.company),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: context.appPalette.textSecondary,
                            fontSize: 13.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: [
                  _infoChip(context, Icons.location_on_outlined,
                      AppText.content(context, job.location)),
                  _infoChip(context, Icons.work_outline,
                      AppText.content(context, job.type)),
                  _infoChip(context, Icons.attach_money, job.salaryRange),
                ],
              ),
              const SizedBox(height: 22),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(AppText.of(context, 'عن الوظيفة', 'About the role'),
                    style: TextStyle(
                        color: context.appPalette.textPrimary,
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
                style: TextStyle(
                    color: context.appPalette.textSecondary,
                    fontSize: 13.5,
                    height: 1.7),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                    AppText.of(context, 'المهارات المطلوبة', 'Required skills'),
                    style: TextStyle(
                        color: context.appPalette.textPrimary,
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
                          backgroundColor:
                              context.appPalette.surfaceIndigoLight,
                          labelStyle: TextStyle(
                              color: context.appPalette.textPrimary,
                              fontSize: 12),
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
                                'اختر التقديم بمساعدة الوكيل أو أرسل طلبك مباشرة إلى الشركة.',
                                'Choose agent assistance or submit your application directly to the company.'),
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
                    alreadyApplied
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: AppColors.success, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                  AppText.of(context, 'تم إرسال طلبك أو حفظه',
                                      'Application submitted or request saved'),
                                  style: const TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w700)),
                            ],
                          )
                        : Column(
                            children: [
                              PinkButton(
                                label: _submittingMode == 'agent'
                                    ? AppText.of(context, 'جارٍ حفظ الطلب...',
                                        'Saving request...')
                                    : AppText.of(
                                        context,
                                        'التقديم بمساعدة الوكيل',
                                        'Apply with agent',
                                      ),
                                icon: Icons.smart_toy_outlined,
                                onPressed:
                                    isSubmitting ? null : _applyWithAgent,
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed:
                                      isSubmitting ? null : _applyManually,
                                  icon: _submittingMode == 'manual'
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.send_outlined),
                                  label: Text(
                                    _submittingMode == 'manual'
                                        ? AppText.of(
                                            context,
                                            'جارٍ إرسال الطلب...',
                                            'Submitting application...',
                                          )
                                        : AppText.of(
                                            context,
                                            'التقديم يدويًا',
                                            'Apply manually',
                                          ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        AppColors.primaryVioletDark,
                                    side: const BorderSide(
                                      color: AppColors.primaryVioletDark,
                                    ),
                                    minimumSize: const Size.fromHeight(48),
                                  ),
                                ),
                              ),
                            ],
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

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.appPalette.surfaceIndigoLight,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(
                  color: context.appPalette.textPrimary, fontSize: 12)),
          const SizedBox(width: 6),
          Icon(icon, size: 14, color: AppColors.accentPink),
        ],
      ),
    );
  }
}
