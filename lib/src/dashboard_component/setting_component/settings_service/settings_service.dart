import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:http/http.dart';
import '../../../../variables.dart';

@Injectable()
class SettingsService {
  var _headers = {
    'Content-type': 'application/json',
    'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
    'tenant-namespace': '${window.sessionStorage['tenant-namespace']}',
    'Authorization': 'Bearer ${window.sessionStorage['token']}'
  };
  static final _profileUrl = '${env['PROFILE_URL']}';
  static final _passwordChange = '${env['LOGIN_PASSWORD']}';
  static final _companyDetailChange = '${env['COMPANY_DETAIL']}';
  final Client _http;

  SettingsService(this._http);

  Future<Response> saveProfile(Profile profile) async {
    try {
      var data = json.decode(window.sessionStorage['x-data']);
      final response = await _http.post(
        _profileUrl + "?company_id=" + data['company_id'],
        headers: _headers,
        body: json.encode({
          'username': profile.username,
          'first_name': profile.firstName,
          'last_name': profile.lastName,
        }),
      );
      print(json.decode(response.body));
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> saveLoginDetails(String oldPassword, String newPassword) async {
    try {
      var data = json.decode(window.sessionStorage['x-data']);
      final response = await _http.post(
        _passwordChange + "?company_id=" + data['company_id'],
        headers: _headers,
        body: json.encode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );
      print(json.decode(response.body));
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> saveCompanyDetails(String companyName, String companyAddress,
      String companyPhoneNumber, String companyEmail) async {
    try {
      var data = json.decode(window.sessionStorage['x-data']);
      final response = await _http.post(
        _companyDetailChange + "?company_id=" + data['company_id'],
        headers: _headers,
        body: json.encode({
          'company_name': companyName,
          'company_address': companyAddress,
          'company_phone_number': companyPhoneNumber,
          'company_email': companyEmail
        }),
      );
      print(json.decode(response.body));
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class Profile {
  String username;
  String firstName;
  String lastName;

  Profile({this.username, this.firstName, this.lastName});
}
