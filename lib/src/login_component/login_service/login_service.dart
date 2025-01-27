import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/variables.dart';
import 'package:http/http.dart' as http;


@Injectable()
class LoginService {
  static final _headers = {
    'Content-type': 'application/json',
    'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
  };
  static final _loginUrl = '${env['LOGIN_URL']}';

  Future<LoginStandardResponse> login(String username, String password) async {
    try {
      final response = await http.post(_loginUrl, headers: _headers,
        body: json.encode({
          'username':username,
          'password' : password
        }));
      window.sessionStorage.clear();
      window.sessionStorage['token'] = response.headers['token'];
      window.sessionStorage['tenant-namespace'] = response.headers['tenant-namespace'];
      final loginData = _extractResponse(response);

      return loginData;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> validateLogin() async {
    bool isValid = await valid(window.sessionStorage['token']);
    if(
        window.sessionStorage.containsKey('token') &&
        window.sessionStorage.containsKey('x-data') &&
        window.sessionStorage.containsKey('tenant-namespace') &&
        window.sessionStorage['token'] != null &&
        window.sessionStorage['x-data'] != null &&
        window.sessionStorage['tenant-namespace'] != null &&
        window.sessionStorage['token'] != '' &&
        window.sessionStorage['x-data'] != '' &&
        window.sessionStorage['tenant-namespace'] != '' &&
        isValid
    ) {
      return true;
    }
      return false;
  }

  Future<bool> valid(String token) async {
    var resp = await http.post(env['VALIDATE_TOKEN_URL'], headers: {'Authorization': 'Bearer $token', 'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6'});
    if(resp.statusCode == 200) {
      return true;
    }
    return false;
  }

  LoginStandardResponse _extractResponse(http.Response resp) {
    var company_data = json.decode(resp.body)['company_data'];
    window.sessionStorage['x-data'] = json.encode(company_data);
    return LoginStandardResponse(statusCode: resp.statusCode, message: json.decode(resp.body)['message']);
  }

  Exception _handleError(dynamic e) {
    return Exception('Server error; cause: $e');
  }
}


class Login {
  String username;
  String password;

  Login(this.username, this.password);

  Map toJson() => {
    'username' : username,
    'password' : password,
  };
}

class LoginStandardResponse {
  int statusCode;
  String message;
  LoginStandardResponse({this.statusCode, this.message});
}


