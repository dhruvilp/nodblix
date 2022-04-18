import 'package:flutter/material.dart';
import 'package:nodblix/services/nodblix_service.dart';

class NodblixPlayground extends StatefulWidget {
  const NodblixPlayground({Key? key}) : super(key: key);

  @override
  State<NodblixPlayground> createState() => _NodblixPlaygroundState();
}

class _NodblixPlaygroundState extends State<NodblixPlayground> {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'app_logo_transparent.png',
              height: 25.0,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Playground'),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Graph echo msg: $_echoMsg',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getEcho,
        tooltip: 'Echo',
        child: const Icon(Icons.webhook_sharp),
      ),
    );
  }
}
