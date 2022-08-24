import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/screens/auth/login.dart';
import 'package:group_planner_app/screens/btm_bar.dart';
import 'package:provider/provider.dart';
import 'consts/firebase_consts.dart';
import 'consts/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return Consumer<ThemeNotifier>(builder: (context, theme, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Group Planner',
        themeMode: theme.getTheme(),
        theme: theme.lightTheme,
        darkTheme: theme.darkTheme,
        home: user == null ? const LoginScreen() : const BottomBarScreen(),
      );
    });
  }
}
