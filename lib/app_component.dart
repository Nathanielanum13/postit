import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_app/src/home_component/home_component.dart' deferred as home_page;
import 'package:angular_app/src/about_component/about_component.dart' deferred as about_page;
import 'package:angular_app/src/login_component/login_component.dart' deferred as login_page;
import 'package:angular_app/src/signup_component/signup_component.dart' deferred as signup_page;
import 'package:angular_app/src/dashboard_component/dashboard_component.dart' deferred as dashboard_page;


@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [routerDirectives, coreDirectives],
  exports: [Routes],
)
class AppComponent implements OnInit, OnDestroy {
  @override
  Future<void> ngOnInit() async {
    await home_page.loadLibrary();
    await about_page.loadLibrary();
    await login_page.loadLibrary();
    await signup_page.loadLibrary();
    await dashboard_page.loadLibrary();
  }


  @override
  void ngOnDestroy() {
    window.localStorage.clear();
  }
}

