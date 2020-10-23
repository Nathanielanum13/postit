import 'package:angular/angular.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'dart:async';
@Component(
    selector: 'nav-app',
    templateUrl: 'navbar_component.html',
    styleUrls: ['navbar_component.css'],
    directives: [
      MaterialButtonComponent,
      MaterialIconComponent,
      routerDirectives
    ],
    exports: [Routes],
)
class NavbarComponent {
//  Do something here
  Router _router;
  NavbarComponent(this._router);

  Future<void> gotoLogin() async {
    _router.navigate(RoutePaths.login.toUrl());
  }
}