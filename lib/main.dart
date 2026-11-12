import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufc_delivery_app/components/app_viewport.dart';
import 'package:ufc_delivery_app/config/config.dart';
import 'package:ufc_delivery_app/config/init_firebase.dart';
import 'package:ufc_delivery_app/generated/codegen_loader.g.dart';
import 'package:ufc_delivery_app/generated/l10n.dart';
import 'package:ufc_delivery_app/providers/theme_provider.dart';
import 'package:ufc_delivery_app/screens/signin_page.dart';
import 'package:ufc_delivery_app/shared/theme/theme.dart';

late SharedPreferences preferences;
int savedLanguageIndex = 0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitFirebase.initializeApp();
  preferences = await SharedPreferences.getInstance();

  AppConfig.token = preferences.getString('token');
  savedLanguageIndex = preferences.getInt("language") ?? 0;
  EasyLocalization.ensureInitialized();
  await SentryFlutter.init(
    (options) {
      options.dsn = kDebugMode
          ? ''
          : 'https://aa7bee5c9436754993001394c3556a51@o4507516184821760.ingest.us.sentry.io/4508720328802304';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.environment = AppConfig.server.name;
    },
    appRunner: () => runApp(
      SentryWidget(
        child: ProviderScope(
          child: EasyLocalization(
            // supportedLocales: const <Locale>[
            //   Locale('ar'),
            //   Locale('en'),
            //   Locale('ur'),
            // ],
            supportedLocales: L10n.all,
            path: 'assets/lang',
            // saveLocale: true,
            // useOnlyLangCode: true,
            // fallbackLocale: const Locale('en'),
            // startLocale: const Locale('en'),
            fallbackLocale: L10n.all[0],
            startLocale: L10n.all[savedLanguageIndex],
            useFallbackTranslations: true,
            assetLoader: const CodegenLoader(),
            child: MyApp(),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UFC Logistics',
      theme: AppTheme.light,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      darkTheme: AppTheme.dark,
      themeMode: theme == AppTheme.dark ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) => AppViewport(child: child!),
      home: Scaffold(
        body: SignInPage(),
      ),
    );
  }
}
