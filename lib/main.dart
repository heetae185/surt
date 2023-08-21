import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surt/provider/participants.dart';
import 'package:surt/screens/screen_database.dart';
import 'package:surt/screens/screen_loading.dart';
import 'package:surt/screens/screen_main.dart';
import 'package:surt/screens/screen_surt.dart';

void main() => runApp(const SuRT());

class SuRT extends StatelessWidget {
  const SuRT({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Participants>(
      create: (context) => Participants(),
      child: MaterialApp(
        title: 'SuRT App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/loading': (context) => const LoadingScreen(),
          '/surt': (context) => const SurtScreen(),
          '/database': (context) => const DatabaseScreen(),
        },
      ),
    );
  }
}
