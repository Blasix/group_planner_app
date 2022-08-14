import 'package:flutter/material.dart';
import 'package:group_planner_app/screens/btm_bar.dart';
import 'package:provider/provider.dart';
import 'consts/theme_manager.dart';

void main() {
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
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, theme, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Group Planner',
        theme: theme.getTheme(),
        home: const BottomBarScreen(),
      );
    });
  }
}
