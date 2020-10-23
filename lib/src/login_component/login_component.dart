import 'package:angular/angular.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

@Component(
    selector: 'login-app',
    templateUrl: 'login_component.html',
    styleUrls: ['login_component.css'],
    directives: [
      MaterialInputComponent,
      MaterialButtonComponent,
      routerDirectives,
    ],
  exports: [Routes]
)
class LoginComponent {
//  Do something here
  Router _router;

  LoginComponent(this._router);
  Future<void> gotoDashboard() async {
    _router.navigate(RoutePaths.dashboard.toUrl());
  }
}