import 'dart:async';
import 'dart:html_common';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_app/src/navbar_component/navbar_component.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_app/src/signup_component/signup_services.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

@Component(
    selector: 'signup-app',
    templateUrl: 'signup_component.html',
    styleUrls: [
      'signup_component.css'
    ],
    directives: [
      routerDirectives,
      NavbarComponent,
      formDirectives,
      coreDirectives,
      MaterialIconComponent,
      MaterialCheckboxComponent,
      MaterialChipsComponent,
      MaterialChipComponent,
      AlertComponent
    ],
    providers: [
      ClassProvider(SignupServices)
    ],
    exports: [
      Routes
    ])
class SignupComponent {
  Router _router;
  SignupServices _signupServices;
  List<String> companyPhoneNumbers = <String>[];
  Signup user = Signup('', '', '', '', '', '', '', '', [], '', false);
  String passwordConfirmation = '';
  String phone = '';
  String message = 'Signup failed';
  bool isLoading = false;

  Alert setAlert;

  SignupComponent(this._signupServices, this._router);

  void addPhone() {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (phone.length == 0) {
      setAlert = Alert('Please enter a phone number', 100);
      return;
    }
    else if (!regExp.hasMatch(phone)) {
      setAlert = Alert('Please enter a valid phone number', 100);
      return;
    }
    if (phone.isNotEmpty) {
      companyPhoneNumbers.add(phone);
      phone = '';
    }
  }

  void removePhone(int index) {
    companyPhoneNumbers.removeAt(index);
  }

  void resetAlert() {
    setAlert = null;
  }

  bool validatePassword(String password) {
    return password.length >= 6 || password == null ? true : false;
  }

  Future<void> signup() async {
    SignupStandardResponse signup =
        SignupStandardResponse(statusCode: null, message: '');

    if(!validatePassword(user.password)) {
      setAlert = Alert('Password is too short', 100);
      return;
    }
    user.companyPhone = companyPhoneNumbers;
    if (user.firstname.isEmpty ||
        user.lastname.isEmpty ||
        user.username.isEmpty ||
        user.password.isEmpty ||
        user.companyName.isEmpty ||
        user.companyAddress.isEmpty ||
        user.companyWebsite.isEmpty ||
        user.ghanaPostAddress.isEmpty ||
        user.companyEmail.isEmpty ||
        user.companyPhone.isEmpty) {

      setAlert = Alert('All input fields are required', 100);
      Timer(Duration(seconds: 5), resetAlert);
      return;
    } else {
      if (user.termsAndConditions && passwordConfirmation == user.password) {
        try {
          isLoading = true;
          signup = await _signupServices.signup(
              user.firstname,
              user.lastname,
              user.username,
              user.password,
              user.companyName,
              user.companyWebsite,
              user.companyAddress,
              user.companyPhone,
              user.companyEmail,
              user.ghanaPostAddress);
          isLoading = false;
          setAlert = Alert(checkMessage(signup.message), 100);
        } catch (e) {
          isLoading = false;
          setAlert = Alert(checkMessage(signup.message), signup.statusCode);
          Timer(Duration(seconds: 5), resetAlert);
        }

        if (signup.statusCode != 200) {
          return;
        } else {
          companyPhoneNumbers.clear();
          user.firstname = '';
          user.lastname = '';
          user.username = '';
          user.password = '';
          user.companyName = '';
          user.companyAddress = '';
          user.companyWebsite = '';
          user.ghanaPostAddress = '';
          user.companyEmail = '';
          user.companyPhone = [];
          passwordConfirmation = '';

          _router.navigate(RoutePaths.dashboard.toUrl());
        }
      } else {
        setAlert = Alert('Confirm password and agree to the terms.', 100);
        Timer(Duration(seconds: 5), resetAlert);
        return;
      }
    }
  }

  String checkMessage(String m) {
    if (m == '') {
      m = 'Login failed';
    }
    return m;
  }
}
