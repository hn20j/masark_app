import 'package:flutter/material.dart';
import '../l10n/app_text.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/job_card.dart';
import 'job_details_screen.dart';

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

  List<Job> get _filtered {
    return DemoData.jobs.where((j) {
      final matchesQuery = _query.isEmpty ||
          j.title.contains(_query) ||
          j.company.contains(_query) ||
          j.tags.any((t) => t.toLowerCase().contains(_query.toLowerCase()));
      final matchesFilter = _filter == 'الكل' || j.type == _filter;
      return matchesQuery && matchesFilter;
    }).toList()
      ..sort((a, b) => b.matchScore.compareTo(a.matchScore));
  }

  @override
  Widget build(BuildContext context) {
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
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              TextField(
                textAlign: TextAlign.start,
                style: const TextStyle(color: AppColors.textDark),
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: AppText.of(
                      context,
                      'ابحث عن وظيفة أو شركة أو مهارة',
                      'Search jobs, companies, or skills'),
                  prefixIcon:
                      const Icon(Icons.tune, color: AppColors.textMuted),
                  suffixIcon:
                      const Icon(Icons.search, color: AppColors.textMuted),
                ),
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
                      selectedColor: AppColors.surfaceIndigoLight,
                      backgroundColor: AppColors.surfaceIndigoLight,
                      labelStyle: TextStyle(
                          color:
                              selected ? Colors.white : AppColors.textSecondary,
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
          child: _filtered.isEmpty
              ? Center(
                  child: Text(
                      AppText.of(context, 'لا توجد نتائج مطابقة',
                          'No matching results'),
                      style: const TextStyle(color: AppColors.textMuted)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final job = _filtered[i];
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
        backgroundColor: AppColors.background, body: SafeArea(child: content));
  }
}
