import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

@Injectable()
class LoginService {

  static final uuid = Uuid().v4().toString();
  static final _headers = {
    'Content-type': 'application/json', 
    'trace-id': uuid,
    'tenant-namespace': 'postit'
  };
  static const _loginUrl = 'https://postit-backend-api.herokuapp.com/login';

  final Client _http;

  LoginService(this._http);

  Future<String> login(String username, String password) async {
    try {
      final response = await http.post(
          _loginUrl,
          headers: _headers,
        body: json.encode({
          'username':username,
          'password' : password
        })
      );
      final token = (_extractPostData(response) as String);
      return token;
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _extractPostData(http.Response resp) => json.decode(resp.body)['token'];

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