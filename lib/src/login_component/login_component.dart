import 'package:angular/angular.dart';
import 'package:angular_app/src/login_component/login_service/login_service.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

@Component(
    selector: 'login-app',
    templateUrl: 'login_component.html',
    styleUrls: ['login_component.css'],
    directives: [
      MaterialInputComponent,
      MaterialButtonComponent,
      routerDirectives,
      coreDirectives,
      formDirectives
    ],
  exports: [Routes],
)
class LoginComponent {
  Router _router;

  Login login = Login('', '');

  LoginComponent(this._router);

  Future<void> gotoDashboard() async {
   _router.navigate(RoutePaths.dashboard.toUrl());
  }
//  Future<void> gotoDashboard() async {
//    login.username.trim();
//
//    if (login.username.isEmpty || login.password.isEmpty){
//      return;
//    }
//
//    var token = await _loginService.login(login.username, login.password);
//    window.localStorage["token"] = token;
//    _router.navigate(RoutePaths.dashboard.toUrl());
//  }
}