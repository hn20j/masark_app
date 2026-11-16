import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarak/models/models.dart';
import 'package:masarak/screens/job_listings_screen.dart';
import 'package:masarak/theme/app_state.dart';
import 'package:masarak/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('search matches all user-facing job text fields', (tester) async {
    final state = AppState()
      ..jobs = [
        Job(
          id: 'job-1',
          title: 'Mobile Developer',
          company: 'Masarak',
          location: 'Erbil',
          salaryRange: r'$600',
          type: 'full-time',
          tags: const ['Flutter'],
          postedAt: DateTime(2026),
          description: 'Build mobile applications',
          experience: 'Senior',
        ),
      ];
    addTearDown(state.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          locale: const Locale('en'),
          theme: AppTheme.darkTheme,
          home: const JobListingsScreen(),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();

    for (final query in [
      'mobile developer',
      'masarak',
      'erbil',
      r'$600',
      'full-time',
      'flutter',
      'mobile applications',
      'senior',
    ]) {
      await tester.enterText(find.byType(TextField), '  $query  ');
      await tester.pump();
      expect(find.text('No matching results'), findsNothing, reason: query);
    }

    await tester.enterText(find.byType(TextField), 'not found');
    await tester.pump();
    expect(find.text('No matching results'), findsOneWidget);
  });
}
