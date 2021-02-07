import 'dart:async';
import 'dart:io' show Platform;
import 'package:angel_framework/angel_framework.dart' show Angel;
import 'package:angel_framework/http.dart' show AngelHttp;
import 'package:angel_static/angel_static.dart' show VirtualDirectory;
import 'package:file/local.dart' show LocalFileSystem;
import 'package:logging/logging.dart' show Logger;

void main() {

  var app = Angel();
  var http = AngelHttp(app);
  var fs = const LocalFileSystem();
  var vDir = VirtualDirectory(
    app,
    fs,
    allowDirectoryListing: true,
    source: fs.directory('./build'),
  );

  app.mimeTypeResolver
    ..addExtension('', 'text/html')
    ..addExtension('dart', 'text/dart')
    ..addExtension('lock', 'text/plain')
    ..addExtension('markdown', 'text/plain')
    ..addExtension('md', 'text/plain')
    ..addExtension('yaml', 'text/plain');

  app.logger = Logger('server.log')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  app.fallback(vDir.handleRequest);
  app.fallback(vDir.pushState('index.html'));

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9939 : int.parse(portEnv);

  runZoned(() async {
    var server = await http.startServer('0.0.0.0', port);
    print('Serving from ${vDir.source.path}');
    print('Listening at http://${server.address.address}:${server.port}');
  }, onError: (e, stackTrace) => print('Oh noes! $e $stackTrace'));
}
