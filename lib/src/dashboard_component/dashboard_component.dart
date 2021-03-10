import 'dart:async';
import 'dart:convert';
import 'dart:html';

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
import 'package:angular_app/src/dashboard_component/post_account_component/post_account_component.dart' deferred as post_account;
import 'package:angular_app/src/dashboard_component/setting_component/setting_component.dart' deferred as settings;
import 'package:angular_app/src/dashboard_component/fb_component/fb_component.dart' deferred as fb;
import 'package:angular_app/src/dashboard_component/setting_component/user_account_component/user_account_component.dart' deferred as user;
import 'package:angular_app/src/login_component/login_component.dart' deferred as login;
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
  bool dropdown = false;
  bool isExpanded = false;
  bool isPerExpanded = false;
  Router _router;
  Location _location;
  var data;
  var appTheme;

  DashboardComponent(this._router, this._location);


  Future<void> goBack() async {
    _location.back();
  }

  Future<void> goForward() async {
    _location.forward();
  }

  void toggleDropdwn() {
    dropdown = !dropdown;
    var drop = getDocument();
    if(dropdown) {
      drop.getElementById('dropdwn-content').style.display = 'block';
    } else {
      drop.getElementById('dropdwn-content').style.display = 'none';
    }
  }

  void dismissDialog() {
    toggle = true;
    showDialog();
  }

  void toggleWidth() {
    isExpanded = !isExpanded;

    if(isExpanded) {
      getDocument().getElementById('persistent-expandable-drawer').classes.remove('small-drawer');
      getDocument().getElementById('persistent-expandable-drawer').classes.add('large-drawer');
    } else {
      getDocument().getElementById('persistent-expandable-drawer').classes.add('small-drawer');
      getDocument().getElementById('persistent-expandable-drawer').classes.remove('large-drawer');
    }
  }
  void togglePerWidth() {
    isPerExpanded = !isPerExpanded;

    if(isPerExpanded) {
      getDocument().getElementById('permanent-expandable-drawer').classes.remove('small-drawer');
    } else {
      getDocument().getElementById('permanent-expandable-drawer').classes.add('small-drawer');
    }
  }

  void doLogout() async {
    window.sessionStorage.clear();

    await login.loadLibrary();
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
    print('about to go down');

    /*if(width <= 576) {
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
    }*/
  }

  @override
  Future<void> ngOnInit() async {
    getData();
    getScreenSize();
  }

  void getData() {
    data = json.decode(window.sessionStorage['x-data']);
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
  }

  @override
  Future<bool> canActivate(RouterState current, RouterState next) async {
    if(
        window.sessionStorage.containsKey('token') &&
        window.sessionStorage.containsKey('tenant-namespace') &&
        window.sessionStorage['token'] != null &&
        window.sessionStorage['tenant-namespace'] != null &&
        window.sessionStorage['token'] != '' &&
        window.sessionStorage['tenant-namespace'] != ''
    ) {
      isLoggedIn = true;
      return true;
    } else {
      isLoggedIn = false;
      _router.navigate(RoutePaths.login.toUrl());
      return false;
    }
  }
}