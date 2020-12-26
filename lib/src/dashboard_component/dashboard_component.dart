
import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_app/src/login_component/login_service/login_service.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:angular_app/src/dashboard_component/create_post_component/create_post_component.dart' deferred as create_post_page;
import 'package:angular_app/src/dashboard_component/view_post_component/view_post_component.dart' deferred as view_post_page;
import 'package:angular_app/src/dashboard_component/manage_post_component/manage_post_component.dart' deferred as manage_post_page;
import 'package:angular_app/src/dashboard_component/dash_home_component/dash_home_component.dart' deferred as dash_home_page;

import 'package:angular_app/variables.dart';
import 'inner_route_paths.dart';

@Component(
  selector: 'dash-app',
  templateUrl: 'dashboard_component.html',
  styleUrls: [
    'dashboard_component.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
  directives: [
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    DeferredContentDirective,
    MaterialToggleComponent,
    formDirectives,
    coreDirectives,
    routerDirectives,
  ],
  exports: [InnerRoutes, InnerRoutePaths, Routes, RoutePaths],
  providers: [
    ClassProvider(LoginService),
  ],
)
class DashboardComponent implements OnInit, CanActivate {

  bool persistentDrawerType = false;
  bool temporaryDrawerType = false;
  bool customWidth = false;
  bool isLoggedIn = false;
  bool nullAction = false;
  bool toggle = false;
  bool end = false;
  bool overlay = true;
  Router _router;
  Location _location;
  LoginService _loginService;
  var data;

  DashboardComponent(this._router, this._location, this._loginService);

  Future<void> goBack() async {
    _location.back();
  }
  Future<void> goForward() async {
    _location.forward();
  }

  void dismissDialog() {
    toggle = true;
    showDialog();
  }

  void doLogout() {
    window.localStorage.clear();

    _router.navigate(RoutePaths.login.toUrl());
  }

  void showDialog() {
    toggle = !toggle;
    var doc = getDocument();
    List<Element> a = doc.querySelectorAll('#html-body button');

    if(toggle) {

      doc.getElementById('log-dialog').setAttribute('display', 'true');
      doc.getElementById('html-body').style.filter = 'blur(5px)';

      for(int i = 0; i < a.length; i++) {
        a[i].setAttribute('disabled', 'true');
      }

    } else {
      doc.getElementById('log-dialog').setAttribute('display', 'false');
      doc.getElementById('html-body').style.filter = 'blur(0px)';

      for(int i = 0; i < a.length; i++) {
        a[i].removeAttribute('disabled');
      }
    }
  }

  void getScreenSize() {

    var a = getDocument();

    int width = a.querySelector('body').clientWidth;

    if(width <= 576) {
      temporaryDrawerType = true;
      persistentDrawerType = false;
    } else if(width > 576 && width <= 720) {
      temporaryDrawerType = true;
      persistentDrawerType = false;
    } else if(width > 720 && width <= 900) {
      temporaryDrawerType = false;
      persistentDrawerType = true;
    } else if(width > 900) {
      temporaryDrawerType = false;
      persistentDrawerType = true;
    }
  }

  @override
  Future<void> ngOnInit() async {
    isLoggedIn = true;
    getData();
    await create_post_page.loadLibrary();
    await view_post_page.loadLibrary();
    await manage_post_page.loadLibrary();
    await dash_home_page.loadLibrary();
  }
  void getData() {
    data = json.decode(window.localStorage['x-data']);
  }

  @override
  Future<bool> canActivate(RouterState current, _) async {
    bool isValidated = await _loginService.validateLogin();
    return isValidated;
  }
}