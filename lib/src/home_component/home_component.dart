import 'package:angular/angular.dart';
import 'package:angular_app/src/navbar_component/navbar_component.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_number_accessor.dart';
import 'package:angular_router/angular_router.dart';

import 'dart:async';

@Component(
  selector: 'home-app',
  templateUrl: 'home_component.html',
  styleUrls: ['home_component.css'],
  directives: [
    MaterialInputComponent,
    MaterialButtonComponent,
    coreDirectives,
    NavbarComponent,
  ],
  exports: [Routes],
)
class HomeComponent {
//  Do something here!
  Router _router;
  HomeComponent(this._router);

  Future<void> gotoAbout() async {
    _router.navigate(RoutePaths.about.toUrl());
  }
}