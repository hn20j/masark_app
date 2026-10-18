import 'package:flutter/material.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarak/screens/company_login_screen.dart';
import 'package:masarak/screens/company_dashboard_screen.dart';
import 'package:masarak/screens/company_signup_screen.dart';
import 'package:masarak/screens/signup_type_screen.dart';
import 'package:masarak/theme/app_state.dart';
import 'package:masarak/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'support/fake_account_repository.dart';

Future<FakeAccountRepository> _pumpCompanySignupScreen(
  WidgetTester tester,
) async {
  final repository = FakeAccountRepository();
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => AppState(
        auth: MockFirebaseAuth(),
        accountRepository: repository,
      ),
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: const CompanySignupScreen(),
      ),
    ),
  );
  return repository;
}

Future<void> _pumpSignInTypeScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => AppState(
        auth: MockFirebaseAuth(),
        accountRepository: FakeAccountRepository(),
      ),
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: const SignupTypeScreen(signInMode: true),
      ),
    ),
  );
}

Future<void> _pumpCompanyLoginScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => AppState(
        auth: MockFirebaseAuth(
          mockUser: MockUser(
            uid: 'company-user',
            email: 'hiring@masarak.example',
            displayName: 'Masarak Ltd',
          ),
        ),
        accountRepository: FakeAccountRepository(),
      ),
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        home: const CompanyLoginScreen(),
      ),
    ),
  );
}

void main() {
  testWidgets('company signup form shows required company fields',
      (tester) async {
    await _pumpCompanySignupScreen(tester);

    expect(find.text('Company name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Country code'), findsOneWidget);
    expect(find.text('Phone number'), findsOneWidget);
    expect(find.text('Hiring contact name'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    expect(find.text('Governorate'), findsOneWidget);
    expect(find.text('I agree to the Terms of Use and Privacy Policy'),
        findsOneWidget);
  });

  testWidgets('company signup inputs use dark text on light fields',
      (tester) async {
    await _pumpCompanySignupScreen(tester);

    for (final field in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(field.style.color, AppColors.textDark);
    }
  });

  testWidgets('company signup requires terms acceptance', (tester) async {
    await _pumpCompanySignupScreen(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create company account'));
    await tester.pumpAndSettle();

    expect(find.text('Accept the Terms of Use to continue.'), findsOneWidget);
  });

  testWidgets('valid company signup opens its dashboard', (tester) async {
    final repository = await _pumpCompanySignupScreen(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'Masarak Ltd');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'hiring@masarak.example',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'company123');
    await tester.enterText(find.byType(TextFormField).at(3), '7701234567');
    await tester.enterText(find.byType(TextFormField).at(4), 'Sara Ahmed');
    await tester
        .ensureVisible(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Baghdad').last);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create company account'));
    await tester.pumpAndSettle();

    expect(find.byType(CompanyDashboardScreen), findsOneWidget);
    expect(find.text('Welcome, Masarak Ltd'), findsOneWidget);
    expect(find.text('Post a new job'), findsOneWidget);
    final account = repository.accounts.values.single;
    expect(account['accountType'], 'company');
    expect(account['phone'], '+964 7701234567');
    expect(account['responsiblePerson'], 'Sara Ahmed');
    expect(account['governorate'], 'Baghdad');
  });

  testWidgets('sign-in account type routes to company sign-in', (tester) async {
    await _pumpSignInTypeScreen(tester);

    await tester.ensureVisible(find.byIcon(Icons.business_outlined).last);
    await tester.tap(find.byIcon(Icons.business_outlined).last);
    await tester.pump();
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(CompanyLoginScreen), findsOneWidget);
    expect(find.text('Company sign in'), findsWidgets);
  });

  testWidgets('company sign-in opens the company dashboard', (tester) async {
    await _pumpCompanyLoginScreen(tester);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'hiring@masarak.example',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'company123');
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.byType(CompanyDashboardScreen), findsOneWidget);
    expect(find.text('Welcome, Masarak Ltd'), findsOneWidget);
  });

  testWidgets('company can publish a job requirement from the dashboard',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const CompanyDashboardScreen(
          companyName: 'Masarak Ltd',
          email: 'hiring@masarak.example',
          phone: '+964 7701234567',
          responsiblePerson: 'Sara Ahmed',
          governorate: 'Baghdad',
        ),
      ),
    );

    await tester.tap(find.text('Post a new job'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'QA Engineer');
    await tester.enterText(find.byType(TextFormField).at(1), 'Baghdad');
    await tester.enterText(
      find.byType(TextFormField).at(5),
      'Test and improve our applications.',
    );
    await tester.drag(find.byType(ListView), const Offset(0, -800));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Publish job'));
    await tester.pumpAndSettle();

    expect(find.text('QA Engineer'), findsOneWidget);
    expect(find.text('Job added to your dashboard.'), findsOneWidget);
  });
}
