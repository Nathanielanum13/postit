import 'package:angular/angular.dart';
import 'package:angular_app/src/navbar_component/navbar_component.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'dart:async';

@Component(
  selector: 'about-app',
  templateUrl: 'about_component.html',
  styleUrls: ['about_component.css'],
  directives: [
    NavbarComponent,
    MaterialIconComponent,
  ],
  exports: [Routes],
)
class AboutComponent {

  Router _router;
  AboutComponent(this._router);

  Future<void> gotoHome() async {
    _router.navigate(RoutePaths.home.toUrl());
  }
}