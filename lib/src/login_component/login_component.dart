import 'dart:html';

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
      /*MaterialInputComponent,
      MaterialButtonComponent,*/
      materialDirectives,
      routerDirectives,
      coreDirectives,
      formDirectives
    ],
  exports: [Routes],
 providers: [ClassProvider(LoginService), materialProviders],
)
class LoginComponent{
 Router _router;
 LoginService _loginService;
 bool isLoading = false;

 Login login = Login('', '');

 LoginComponent(this._router, this._loginService);


  Future<void> gotoDashboard() async {
   LoginStandardResponse loginResponse;
   login.username.trim();

   if (login.username.isEmpty || login.password.isEmpty){
     return;
   }

   try {
     isLoading = true;
     loginResponse = await _loginService.login(login.username, login.password);
     isLoading = false;
   } catch(e) {
     isLoading = false;
     print('Error trying to connect');
   }

   print('Message: ${loginResponse.message}');

   if(loginResponse.statusCode != 200)  {
     return;
   } else {
     _router.navigate(RoutePaths.dashboard.toUrl());
   }
  }

}