import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/push_notification_service.dart';
import 'services/account_repository.dart';
import 'screens/splash_screen.dart';
import 'theme/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationService.instance.initialize();
  runApp(const MasarakApp());
}

class MasarakApp extends StatelessWidget {
  final FirebaseAuth? auth;
  final AccountRepository? accountRepository;
  const MasarakApp({super.key, this.auth, this.accountRepository});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => AppState(
          auth: auth,
          accountRepository: accountRepository,
        )..loadLocale(),
        child: Consumer<AppState>(
          builder: (context, state, _) => MaterialApp(
            title: 'مسارك',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: state.locale,
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) => Directionality(
              textDirection: state.locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            ),
            home: const SplashScreen(),
          ),
        ),
      );
}
