import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_app/src/login_component/login_service/login_service.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_app/variables.dart';
import 'package:http/http.dart';

@Component(
  selector: 'login-app',
  templateUrl: 'login_component.html',
  styleUrls: ['login_component.css'],
  directives: [
    materialDirectives,
    routerDirectives,
    coreDirectives,
    formDirectives,
    AlertComponent,
  ],
  exports: [Routes, RoutePaths],
  providers: [
    ClassProvider(LoginService), 
    materialProviders,
  ],
)
class LoginComponent{
  Router _router;
  LoginService _loginService;
  bool isLoading = false;
  bool showAlert = false;
  bool isEye = false;
  int statusCode = 400;
  String type = 'password';
  String message = 'Login failed';
  Alert setAlert;
  Client _http;

  Login login = Login('', '');

  LoginComponent(this._router, this._loginService, this._http);


  void tryLogin() {
    if (login.username.isNotEmpty && login.password.isNotEmpty) {
      gotoDashboard();
    } else
      return;
  }

  void show() {
    isEye = !isEye;
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
      setAlert = Alert(loginResponse.message, loginResponse.statusCode);
      Timer(Duration(seconds: 5), resetAlert);
    } catch (e) {
      isLoading = false;
      setAlert = Alert(checkMessage(loginResponse.message), loginResponse.statusCode);
      Timer(Duration(seconds: 5), resetAlert);
    }

    if (loginResponse.statusCode != 200) {
      return;
    } else {
      bool isValid = await valid(window.sessionStorage['token']);

      if(isValid) {
      _router.navigate(RoutePaths.dashboard.toUrl());
      } else {
        return;
      }
    }
  }

  void resetAlert() {
    setAlert = null;
  }

  Future<bool> valid(String token) async {
    var resp = await _http.post(env['VALIDATE_TOKEN_URL'], headers: {'Authorization': 'Bearer $token', 'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6'});
    if(resp.statusCode == 200) {
      return true;
    }
    return false;
  }

  String checkMessage(String m) {
    return m == '' ? 'Login failed' : m;
  }
}
