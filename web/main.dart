import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_app/post_it_app_component.template.dart' as postit;
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import 'main.template.dart' as self;

@GenerateInjector([
  routerProvidersHash,
  ClassProvider(Client, useClass: BrowserClient),
  ValueProvider.forToken(appBaseHref, '/'),
])
final InjectorFactory injector = self.injector$Injector;

void main() {
  runApp(postit.PostItAppComponentNgFactory, createInjector: injector);
}
