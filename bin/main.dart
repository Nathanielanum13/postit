import 'dart:io' show File, HttpServer, InternetAddress, Platform;
import 'dart:async';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart' show join, dirname;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart' as shelf;

Future<void> main() async {

  var pathToBuild = join(dirname(Platform.script.toFilePath()), '..', 'build');
  var staticFiles = VirtualDirectory(pathToBuild);

//  staticFiles.followLinks = true;
  staticFiles.allowDirectoryListing = true;
  staticFiles.directoryHandler = (dir, req) {
    var indexUri = Uri.file(dir.path).resolve('index.html');
    staticFiles.serveFile(File(indexUri.toFilePath()), req);
  };

  var portEnv = Platform.environment['PORT'];
  var port = portEnv == null ? 9939 : int.parse(portEnv);

  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('Serving on ${server.address.host}:${server.port}');
  await server.forEach(staticFiles.serveRequest);
}
