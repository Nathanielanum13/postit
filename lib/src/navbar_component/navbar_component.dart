import 'package:angular/angular.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import 'dart:async';

@Component(
    selector: 'nav-app',
    templateUrl: 'navbar_component.html',
    styleUrls: ['navbar_component.css'],
    directives: [
      MaterialButtonComponent,
      MaterialIconComponent,
      formDirectives,
      coreDirectives,
      routerDirectives,
    ],
    exports: [Routes],
)

class NavbarComponent {
  Router _router;
  NavbarComponent(this._router);

  Future<void> gotoLogin() async {
    _router.navigate(RoutePaths.login.toUrl());
  }

}