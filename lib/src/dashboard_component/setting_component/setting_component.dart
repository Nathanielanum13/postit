import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/inner_route_paths.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'setting-app',
  templateUrl: 'setting_component.html',
  styleUrls: ['setting_component.css'],
  directives: [
    routerDirectives,
    coreDirectives,
    formDirectives,
  ],
  exports: [InnerRoutePaths, InnerRoutes]
)
class SettingComponent {
  Router _router;
  bool search = false;

  SettingComponent(this._router);
  void displaySearch() {
    search = !search;
  }

  void routeToUserSettings() {
    _router.navigate(InnerRoutePaths.user_account.toUrl());
  }

  void gotoUserSettings(Element element) {
    element.setAttribute('animation-explode', 'true');
    print(element.getAttribute('animation-explode'));

    Timer(Duration(milliseconds: 450), routeToUserSettings);
  }
}
