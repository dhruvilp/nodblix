import 'package:flutter/material.dart';
import 'package:nodblix/services/nodblix_service.dart';

import '../services/storage_manager.dart';
import '../widgets/playground_view.dart';

class NodblixPlayground extends StatefulWidget {
  const NodblixPlayground({Key? key}) : super(key: key);

  @override
  State<NodblixPlayground> createState() => _NodblixPlaygroundState();
}

class _NodblixPlaygroundState extends State<NodblixPlayground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_logo_transparent.png',
              height: 25.0,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Playground'),
            ),
          ],
        ),
      ),
      body: const PlaygroundView(),
    );
  }
}
