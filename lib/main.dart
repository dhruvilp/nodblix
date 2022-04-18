import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nodblix/pages/landing_page.dart';
import 'package:nodblix/pages/nodblix_playground.dart';
import 'package:url_strategy/url_strategy.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nodblix',
      theme: ThemeData(
        primaryColor: const Color(0xFF17FF8E),
        scaffoldBackgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
        cardTheme: CardTheme(
          color: Colors.grey[850],
          elevation: 5.0,
        ),
        primaryTextTheme: ThemeData.dark().textTheme,
      ),
      themeMode: ThemeMode.dark,
      home: const LandingPage(),
      routes: <String, WidgetBuilder>{
        '/playground': (BuildContext context) => const NodblixPlayground(),
      },
    );
  }
}
