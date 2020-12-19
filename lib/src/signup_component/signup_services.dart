import 'dart:convert';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:http/http.dart';
import 'package:angular_app/variables.dart';


@Injectable()
class SignupServices {
  Client _http;
  static final _headers = {
    'Content-type': 'application/json',
    'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
  };
  static final _signupUrl = '${env['SIGNUP_URL']}';

  SignupServices(this._http);

  // ignore: missing_return
  Future<SignupStandardResponse> signup(String firstname, lastname, username, password, companyName, companyWebsite, companyAddress, companyPhone, companyEmail, ghanaPostAddress) async {
    try {
      final response = await _http.post(
        _signupUrl,
        headers: _headers,
          body: json.encode({
            'admin_first_name' : firstname,
            'admin_last_name' : lastname,
            'username' : username,
            'password' : password,
            'company_name' : companyName,
            'company_website' : companyWebsite,
            'company_address' : companyAddress,
            'company_contact_number' : companyPhone,
            'company_email' : companyEmail,
            'ghana_post_address' : ghanaPostAddress,
          }));

      window.localStorage['token'] = response.headers['token'];
      window.localStorage['tenant-namespace'] = response.headers['tenant-namespace'];

      return _extractResponse(response);
    } catch(e) {
      print('Error: $e');
    }
  }

  SignupStandardResponse _extractResponse(Response resp) {
    return SignupStandardResponse(statusCode: resp.statusCode, message: json.decode(resp.body)['message']);
  }
}
class Signup {
  String firstname;
  String lastname;
  String username;
  String password;

  String companyName;
  String companyWebsite;
  String companyAddress;
  String companyEmail;
  List<String> companyPhone;
  String ghanaPostAddress;
  String createdAt;
  String updatedAt;
  String id;

  bool termsAndConditions;

  Signup(
      this.firstname,
      this.lastname,
      this.username,
      this.password,
      this.companyName,
      this.companyWebsite,
      this.companyAddress,
      this.companyEmail,
      this.companyPhone,
      this.ghanaPostAddress,
      this.termsAndConditions,
      {
        this.createdAt,
        this.updatedAt,
        this.id,
      }
      );
}

class SignupStandardResponse {
  int statusCode;
  String message;

  SignupStandardResponse({this.statusCode, this.message});
}


