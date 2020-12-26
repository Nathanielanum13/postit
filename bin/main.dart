//import 'dart:developer';
//import 'dart:io' show File, HttpServer, InternetAddress, Platform;
import 'dart:async';
import 'dart:io' show Platform;
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_static/angel_static.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';

void main() {

  var app = Angel();
  var http = AngelHttp(app);
  var fs = const LocalFileSystem();
  var vDir = CachingVirtualDirectory(
    app,
    fs,
    allowDirectoryListing: true,
    source: fs.directory('./build') /*args.isEmpty ? fs.currentDirectory : fs.directory(args[0])*/,
    maxAge: const Duration(days: 24).inSeconds,
  );

  app.mimeTypeResolver
    ..addExtension('', 'text/html')
    ..addExtension('dart', 'text/dart')
    ..addExtension('lock', 'text/plain')
    ..addExtension('markdown', 'text/plain')
    ..addExtension('md', 'text/plain')
    ..addExtension('yaml', 'text/plain');
//    ..addEx

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
