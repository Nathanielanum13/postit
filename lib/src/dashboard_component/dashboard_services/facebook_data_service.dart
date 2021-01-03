import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/variables.dart';
import 'package:http/http.dart';

@Injectable()
class FacebookDataService {
  static final _headers = {
    'Content-type': 'application/json',
    'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
    'tenant-namespace': '${window.localStorage['tenant-namespace']}',
    'Authorization': 'Bearer ${window.localStorage['token']}'
  };

  static final _facebookUrl = '${env['FACEBOOK_URL']}';


  Future<Response> sendCodeToApi(String code) async {
    Map FacebookRequestObject = {
      'code': code,
    };

    Response response = await post(_facebookUrl, headers: _headers, body: json.encode(FacebookRequestObject));

    return response;
  }
}