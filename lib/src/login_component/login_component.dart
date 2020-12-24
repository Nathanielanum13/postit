import 'dart:async';
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
    materialDirectives,
    routerDirectives,
    coreDirectives,
    formDirectives
  ],
  exports: [Routes, RoutePaths],
  providers: [ClassProvider(LoginService), materialProviders, routerProviders],
)
class LoginComponent implements CanReuse {
  Router _router;
  LoginService _loginService;
  bool isLoading = false;
  bool showAlert = false;
  int statusCode = 400;
  String message = 'Login failed';

  Login login = Login('', '');

  LoginComponent(this._router, this._loginService);

  void dismissAlert() {
    showAlert = false;
  }

  void tryLogin() {
    if (login.username.isNotEmpty && login.password.isNotEmpty) {
      gotoDashboard();
    } else
      return;
  }

  Future<void> gotoDashboard() async {
    LoginStandardResponse loginResponse =
        LoginStandardResponse(statusCode: null, message: '');
    login.username.trim();

    if (login.username.isEmpty || login.password.isEmpty) {
      return;
    }

    try {
      isLoading = true;
      loginResponse = await _loginService.login(login.username, login.password);
      isLoading = false;
      showAlert = true;
      statusCode = loginResponse.statusCode;
      message = checkMessage(loginResponse.message);
      Timer(Duration(seconds: 5), dismissAlert);
    } catch (e) {
      isLoading = false;
      showAlert = true;
      statusCode = loginResponse.statusCode;
      message = checkMessage(loginResponse.message);
      Timer(Duration(seconds: 5), dismissAlert);
    }

    if (loginResponse.statusCode != 200) {
      return;
    } else {
      _router.navigate(RoutePaths.dashboard.toUrl());
    }
  }

  String checkMessage(String m) {
    if (m == '') {
      m = 'Login failed';
    }
    return m;
  }

  @override
  Future<bool> canReuse(RouterState current, RouterState next) async {
    return true;
  }
}
