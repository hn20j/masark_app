import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarak/theme/app_theme.dart';
import 'package:masarak/widgets/animated_search_button.dart';

void main() {
  testWidgets('expands for search input and collapses on close',
      (tester) async {
    String? query;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
          ),
          extensions: const [
            AppPalette(
              background: Color(0xFFF6F5F8),
              surfaceIndigo: Colors.white,
              surfaceIndigoLight: Color(0xFFEDEAF3),
              textPrimary: Color(0xFF211E28),
              textSecondary: Color(0xFF625D6B),
              textMuted: Color(0xFF777180),
              outline: Color(0x1A241E30),
              heroGradient: LinearGradient(
                colors: [Colors.white, Color(0xFFF6F5F8)],
              ),
            ),
          ],
        ),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: AnimatedSearchButton(
                hintText: 'Search jobs, companies, or skills',
                onChanged: (value) => query = value,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsNothing);
    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search jobs, companies, or skills'), findsOneWidget);
    final inputDecorator =
        tester.widget<InputDecorator>(find.byType(InputDecorator));
    expect(inputDecorator.decoration.filled, isFalse);
    await tester.enterText(find.byType(TextField), 'designer');
    expect(query, 'designer');

    await tester.tap(find.byTooltip('Close search'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
  });
}
