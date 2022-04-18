import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nodblix/services/nodblix_service.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nodblix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Nodblix'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _echoMsg = '';

  Future<void> _getEcho() async {
    try {
      Map<String, dynamic>? echoMsgResp = await NodblixService.fetchEcho();
      if (echoMsgResp!.isNotEmpty) {
        setState(() {
          _echoMsg = echoMsgResp['message'];
        });
      }
    } catch (e) {
      print('==== echo error from ui: $e');
    }
  }

  Future<void> _getRequestToken() async {
    try {
      Map<String, dynamic>? reqTokenResp =
          await NodblixService.fetchRequestToken();
      if (reqTokenResp!.isNotEmpty) {
        setState(() {
          _echoMsg = reqTokenResp['token'];
        });
      }
    } catch (e) {
      print('==== echo error from ui: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Graph echo msg: $_echoMsg',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getRequestToken,
        tooltip: 'Echo',
        child: const Icon(Icons.webhook_sharp),
      ),
    );
  }
}
