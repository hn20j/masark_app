import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../theme/app_state.dart';
import '../widgets/job_card.dart';
import '../widgets/animated_search_button.dart';
import 'job_details_screen.dart';
import 'package:provider/provider.dart';

class JobListingsScreen extends StatefulWidget {
  final bool embedded; // true when hosted inside HomeScreen's bottom nav shell
  const JobListingsScreen({super.key, this.embedded = false});

  @override
  State<JobListingsScreen> createState() => _JobListingsScreenState();
}

class _JobListingsScreenState extends State<JobListingsScreen> {
  String _query = '';
  String _filter = 'الكل';
  final _filters = const ['الكل', 'دوام كامل', 'عن بُعد', 'دوام جزئي'];

  List<Job> _filtered(List<Job> jobs) {
    final query = _query.trim().toLowerCase();
    return jobs.where((j) {
      final searchableText = [
        j.title,
        j.company,
        j.location,
        j.salaryRange,
        j.type,
        ...j.tags,
        if (j.description != null) j.description!,
        if (j.experience != null) j.experience!,
      ];
      final matchesQuery = query.isEmpty ||
          searchableText.any((text) => text.toLowerCase().contains(query));
      final type = j.type.toLowerCase();
      final matchesFilter = _filter == 'الكل' ||
          j.type == _filter ||
          (_filter == 'دوام كامل' && type.contains('full')) ||
          (_filter == 'عن بُعد' && type.contains('remote')) ||
          (_filter == 'دوام جزئي' && type.contains('part'));
      return matchesQuery && matchesFilter;
    }).toList()
      ..sort((a, b) => b.postedAt.compareTo(a.postedAt));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final filteredJobs = _filtered(state.jobs);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  AppText.of(
                      context, 'الفرص المتاحة', 'Available opportunities'),
                  style: TextStyle(
                      color: context.appPalette.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              AnimatedSearchButton(
                hintText: AppText.of(
                  context,
                  'ابحث في تفاصيل الوظيفة',
                  'Search all job details',
                ),
                searchLabel: AppText.of(context, 'بحث', 'Search'),
                closeLabel: AppText.of(context, 'إغلاق البحث', 'Close search'),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final f = _filters[i];
                    final label = switch (f) {
                      'الكل' => AppText.of(context, 'الكل', 'All'),
                      'دوام كامل' =>
                        AppText.of(context, 'دوام كامل', 'Full-time'),
                      'عن بُعد' => AppText.of(context, 'عن بُعد', 'Remote'),
                      'دوام جزئي' =>
                        AppText.of(context, 'دوام جزئي', 'Part-time'),
                      _ => f,
                    };
                    final selected = f == _filter;
                    return ChoiceChip(
                      label: Text(label),
                      selected: selected,
                      onSelected: (_) => setState(() => _filter = f),
                      selectedColor: AppColors.primaryViolet,
                      backgroundColor: context.appPalette.surfaceIndigoLight,
                      labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : context.appPalette.textSecondary,
                          fontSize: 12.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                          side: BorderSide.none),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: state.jobsLoading
              ? const Center(child: CircularProgressIndicator())
              : state.jobsError != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          state.jobsError!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    )
                  : filteredJobs.isEmpty
                      ? Center(
                          child: Text(
                              AppText.of(context, 'لا توجد نتائج مطابقة',
                                  'No matching results'),
                              style:
                                  const TextStyle(color: AppColors.textMuted)),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: filteredJobs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final job = filteredJobs[i];
                            return JobCard(
                              job: job,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => JobDetailsScreen(job: job)),
                              ),
                            );
                          },
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
