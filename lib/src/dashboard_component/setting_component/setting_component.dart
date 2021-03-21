import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/inner_route_paths.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
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
    AlertComponent,
  ],
  exports: [InnerRoutePaths, InnerRoutes],
)
class SettingComponent implements OnInit{
  Router _router;
  bool search = false;
  var appTheme;
  Alert setAlert;

  SettingComponent(this._router);
  void displaySearch() {
    search = !search;
  }

  void resetAlert() {
    setAlert = null;
  }

  void routeToUserSettings() {
    /*_router.navigate(InnerRoutePaths.user_account.toUrl());*/
    setAlert = Alert('Route Initializing', 200);
    Timer(Duration(seconds: 5), resetAlert);
  }
  void routeToPostAccountSettings() {
    /*_router.navigate(InnerRoutePaths.post_account_settings.toUrl());*/
  }
  void routeToTheme() {
    _router.navigate(InnerRoutePaths.theme.toUrl());
  }
  void routeToAppbackground() {
    _router.navigate(InnerRoutePaths.app_background.toUrl());
  }
  void routeToNavigationSettings() {
    _router.navigate(InnerRoutePaths.navigation_settings.toUrl());
  }

  void gotoSettings(Element element) {
    element.setAttribute('animation-explode', 'false');

    String item = element.getAttribute('id');

    switch(item) {
      case 'user-settings' : Timer(Duration(milliseconds: 350), routeToUserSettings); break;
      case 'post-account-settings': Timer(Duration(milliseconds: 350), routeToPostAccountSettings); break;
      case 'theme': Timer(Duration(milliseconds: 350), routeToTheme); break;
      case 'app-background': Timer(Duration(milliseconds: 350), routeToAppbackground); break;
      case 'navigation-settings': Timer(Duration(milliseconds: 350), routeToNavigationSettings); break;
    }
  }

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
  }
}
