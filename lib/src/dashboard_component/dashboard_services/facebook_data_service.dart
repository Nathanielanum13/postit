import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/variables.dart';
import 'package:http/http.dart';

@Injectable()
class FacebookDataService {

  final Client _http;

  //   Set the headers to be used by the class
  static final _headers = {
    'Content-type': 'application/json',
    'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
    'tenant-namespace': '${window.localStorage['tenant-namespace']}',
    'Authorization': 'Bearer ${window.localStorage['token']}'
  };

  FacebookDataService(this._http);

  // Get the facebook url from the env file
  static final _facebookUrl = '${env['FACEBOOK_URL']}';

  Future<Response> sendCodeToApi(String code) async {
    print('Received code: $code');
    // Store the code in a map
    Map FacebookRequestObject = {
      'code': code,
    };
    // Send the code data to the backend
    final Response response = await _http.post(_facebookUrl, headers: _headers, body: json.encode(FacebookRequestObject));
    return response;
  }

  Future<List<String>> getAllFacebookData() async {
    final Response resp = await _http.get(_facebookUrl, headers: _headers);

    var body = json.decode(resp.body)['data'];
    print(body);
    List<String> usernames = convertLDS(body);
    print('usernames: $usernames');
    return usernames;
  }

  List<String> convertLDS(List<dynamic> dyn) {
    List<String> converted = <String>[];
    try {
      for (int i = 0; i < dyn.length; i++) {
        converted.add(dyn.elementAt(i).toString());
      }
      return converted;
    } catch (e) {
      converted = ['No Account'];
      return converted;
    }
  }
}