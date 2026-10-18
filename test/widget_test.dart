// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masarak/auth/iraqi_phone_number.dart';
import 'package:masarak/main.dart';
import 'package:masarak/screens/cv_upload_screen.dart';
import 'package:masarak/screens/home_screen.dart';
import 'package:masarak/screens/login_screen.dart';
import 'package:masarak/screens/notifications_screen.dart';
import 'package:masarak/screens/signup_screen.dart';
import 'package:masarak/theme/app_state.dart';
import 'package:masarak/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'support/fake_account_repository.dart';

void main() {
  test('Iraqi phone numbers normalize to +964', () {
    expect(normalizeIraqiPhoneNumber('7701234567'), '+9647701234567');
    expect(normalizeIraqiPhoneNumber('0770 123 4567'), '+9647701234567');
    expect(normalizeIraqiPhoneNumber('+964 770 123 4567'), '+9647701234567');
    expect(normalizeIraqiPhoneNumber('1234567890'), isNull);
  });

  test('application preferences persist and survive profile edits', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = FakeAccountRepository();
    final state = AppState(
      auth: MockFirebaseAuth(
        mockUser: MockUser(uid: 'preferences-user', email: 'demo@example.com'),
      ),
      accountRepository: repository,
    );
    await state.authReady;
    await state.signIn(
      email: 'demo@example.com',
      password: 'demo123',
      homeCountry: 'Iraq',
    );

    await state.saveApplicationPreferences(
      targetRoles: ['طبيب'],
      skills: ['Patient Care', 'CPR'],
      careerCategory: 'medical',
      universityMajor: 'الطب البشري',
      yearsExperience: '3',
      remoteOk: false,
    );

    expect(state.currentUser?.workPreferences, ['طبيب']);
    expect(state.currentUser?.skills, ['Patient Care', 'CPR']);
    expect(state.currentUser?.preferredCountry, 'Iraq');
    expect(state.currentUser?.remoteOk, isFalse);

    await state.updateProfileDetails(
      birthdate: DateTime(1998, 5, 10),
      governorate: 'Baghdad',
      governorateRegion: 'Karrada',
      academicAchievement: 'Bachelor degree',
      workPreferences: ['Doctor'],
      workLocation: 'Baghdad',
    );

    final stored = repository.accounts['preferences-user']!;
    expect(stored['skills'], ['Patient Care', 'CPR']);
    expect(stored['careerCategory'], 'medical');
    expect(stored['governorate'], 'Baghdad');
  });

  test('company profile is saved and restored by Firebase UID', () async {
    final repository = FakeAccountRepository();
    final auth = MockFirebaseAuth(
      mockUser: MockUser(
        uid: 'company-profile-user',
        email: 'login@masarak.example',
        displayName: 'Masarak Ltd',
      ),
    );
    final state = AppState(auth: auth, accountRepository: repository);
    await state.authReady;
    await state.signIn(
      email: 'login@masarak.example',
      password: 'company123',
      homeCountry: 'Iraq',
      accountType: 'company',
    );
    await state.updateCompanyProfile(
      companyName: 'Masarak Iraq',
      contactEmail: 'contact@masarak.example',
      phone: '+964 7701234567',
      responsiblePerson: 'Sara Ahmed',
      governorate: 'Baghdad',
    );

    expect(
        repository.accounts['company-profile-user']?['accountType'], 'company');
    expect(repository.accounts['company-profile-user']?['phone'],
        '+964 7701234567');
    expect(repository.accounts['company-profile-user']?['companyContactEmail'],
        'contact@masarak.example');

    final restored = AppState(
      auth: MockFirebaseAuth(
        mockUser: MockUser(
          uid: 'company-profile-user',
          email: 'login@masarak.example',
        ),
      ),
      accountRepository: repository,
    );
    await restored.authReady;
    await restored.signIn(
      email: 'login@masarak.example',
      password: 'company123',
      homeCountry: 'Iraq',
      accountType: 'company',
    );

    expect(restored.currentUser?.name, 'Masarak Iraq');
    expect(restored.currentUser?.responsiblePerson, 'Sara Ahmed');
    expect(restored.currentUser?.governorate, 'Baghdad');
  });

  test('company accounts cannot sign in through employee flow', () async {
    final repository = FakeAccountRepository()
      ..accounts['company-user'] = {
        'uid': 'company-user',
        'name': 'Masarak Ltd',
        'email': 'login@masarak.example',
        'accountType': 'company',
        'homeCountry': 'Iraq',
        'profileCompletion': 0.2,
      };
    final state = AppState(
      auth: MockFirebaseAuth(
        mockUser: MockUser(
          uid: 'company-user',
          email: 'login@masarak.example',
        ),
      ),
      accountRepository: repository,
    );
    await state.authReady;

    await expectLater(
      state.signIn(
        email: 'login@masarak.example',
        password: 'company123',
        homeCountry: 'Iraq',
      ),
      throwsA(
        isA<FirebaseAuthException>().having(
          (error) => error.code,
          'code',
          'account-type-mismatch',
        ),
      ),
    );
  });

  testWidgets('app starts and shows splash screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(MasarakApp(
      auth: MockFirebaseAuth(),
      accountRepository: FakeAccountRepository(),
    ));

    expect(find.text('مسارك'), findsWidgets);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('language selector changes locale and text direction',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(MasarakApp(
      auth: MockFirebaseAuth(),
      accountRepository: FakeAccountRepository(),
    ));

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('AI-powered career guidance'), findsOneWidget);
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
        const Locale('en'));
    final taglineContext =
        tester.element(find.text('AI-powered career guidance'));
    expect(Directionality.of(taglineContext), TextDirection.ltr);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('languageCode'), 'en');
  });

  testWidgets('notifications screen shows heading and items', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      locale: Locale('ar'),
      supportedLocales: [Locale('ar'), Locale('en')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: NotificationsScreen(),
    ));

    expect(find.text('الإشعارات'), findsOneWidget);
    expect(find.text('تم تحديث حالة طلبك'), findsOneWidget);
  });

  testWidgets('sign in accepts valid details and opens home', (tester) async {
    final state = AppState(
      auth: MockFirebaseAuth(
        mockUser: MockUser(email: 'demo@example.com'),
      ),
      accountRepository: FakeAccountRepository(),
    );
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: state,
      child: const MaterialApp(
        locale: Locale('en'),
        home: LoginScreen(),
      ),
    ));

    await tester.enterText(
        find.byType(TextFormField).at(0), 'demo@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'demo123');
    final signInButton = find.byType(PrimaryButton);
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    expect(state.currentUser?.email, 'demo@example.com');
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('phone sign in uses the Iraqi country code', (tester) async {
    final state = AppState(
      auth: MockFirebaseAuth(),
      accountRepository: FakeAccountRepository(),
    );
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: state,
      child: const MaterialApp(
        locale: Locale('en'),
        home: LoginScreen(),
      ),
    ));

    await tester.tap(find.text('Phone'));
    await tester.pumpAndSettle();

    final phoneField = tester.widget<TextField>(find.byType(TextField));
    expect(phoneField.decoration?.prefixText, '+964 ');
    expect(phoneField.decoration?.hintText, '7XXXXXXXXX');
    expect(find.text('Send code'), findsOneWidget);
    expect(find.text('Forgot password?'), findsNothing);
  });

  testWidgets('sign up creates profile and opens CV upload', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = FakeAccountRepository();
    final state = AppState(
      auth: MockFirebaseAuth(),
      accountRepository: repository,
    );
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: state,
      child: const MaterialApp(
        locale: Locale('en'),
        home: SignupScreen(),
      ),
    ));

    await tester.enterText(find.byType(TextFormField).at(0), 'Demo Person');
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Baghdad').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(2), 'Karrada');
    await tester.enterText(find.byType(TextFormField).at(3), 'Bachelor degree');
    final jobField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'Example: Accountant',
    );
    await tester.enterText(jobField, 'Accountant');
    final addJobButton = find.byTooltip('Add job');
    await tester.ensureVisible(addJobButton);
    await tester.tap(addJobButton);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(4), 'Baghdad');
    await tester.enterText(
        find.byType(TextFormField).at(5), 'demo@example.com');
    await tester.enterText(find.byType(TextFormField).at(6), 'demo123');
    final signUpButton = find.byType(PrimaryButton);
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    expect(state.currentUser?.name, 'Demo Person');
    expect(state.currentUser?.email, 'demo@example.com');
    expect(state.currentUser?.governorate, 'Baghdad');
    expect(state.currentUser?.governorateRegion, 'Karrada');
    expect(state.currentUser?.academicAchievement, 'Bachelor degree');
    expect(state.currentUser?.workPreferences, ['Accountant']);
    expect(state.currentUser?.workLocation, 'Baghdad');
    final account = repository.accounts[state.currentUser!.uid]!;
    expect(account['accountType'], 'employee');
    expect(account['governorate'], 'Baghdad');
    expect(account['workPreferences'], ['Accountant']);
    expect(find.byType(CvUploadScreen), findsOneWidget);
  });
}
