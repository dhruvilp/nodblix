import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';

Future<void> main() async {
  final server = await shelf_io.serve(
    proxyHandler('https://nodblix.vercel.app'),
    'localhost',
    8080,
  );

  print('Proxying at http://${server.address.host}:${server.port}');
}
