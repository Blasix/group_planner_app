import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:group_planner_app/fetch.dart';
import 'package:group_planner_app/providers/member_provider.dart';
import 'package:group_planner_app/providers/team_provider.dart';
import 'package:group_planner_app/screens/auth/login.dart';
import 'package:provider/provider.dart';
import 'consts/firebase_consts.dart';
import 'consts/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// IF MacOS gives errors run:
// in ios: pod update

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final User? user = authInstance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TeamProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MemberProvider(),
        ),
      ],
      child: Consumer<ThemeNotifier>(builder: (context, theme, child) {
        return MaterialApp(
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'Group Planner',
          themeMode: theme.getTheme(),
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          home: (user == null) ? const LoginScreen() : const Fetch(),
        );
      }),
    );
  }
}
