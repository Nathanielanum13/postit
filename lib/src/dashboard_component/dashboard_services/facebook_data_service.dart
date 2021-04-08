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
    'tenant-namespace': '${window.sessionStorage['tenant-namespace']}',
    'Authorization': 'Bearer ${window.sessionStorage['token']}'
  };

  FacebookDataService(this._http);

  // Get the facebook url from the env file
  static final _facebookUrl = '${env['FACEBOOK_LOGIN_URL']}';
  static final _deleteFacebookAccountUrl =
      '${env['DELETE_FACEBOOK_ACCOUNT_URL']}';
  static final _getAllPostAccountsUrl = '${env['ALL_ACCOUNTS_URL']}';

  Future<Response> sendCodeToApi(String code) async {
    print('Received code: $code');
    // Store the code in a map
    Map FacebookRequestObject = {
      'code': code,
    };
    // Send the code data to the backend
    final Response response = await _http.post(_facebookUrl,
        headers: _headers, body: json.encode(FacebookRequestObject));
    return response;
  }

  Future<Datar> getAllAccountData() async {
    final Response resp = await _http.get(_getAllPostAccountsUrl, headers: _headers);
    return _extractDataResponse(json.decode(resp.body)['data']);
  }

  Future<void> deleteFacebookAccount(String userId) async {
    final resp = await _http.delete(
        _deleteFacebookAccountUrl + '?app_id=' + userId,
        headers: _headers);
    if (resp.statusCode != 200) {
      return;
    }
  }

  List<String> convertLDS(List<dynamic> dyn) {
    List<String> converted = <String>[];
    try {
      for (int i = 0; i < dyn.length; i++) {
        converted.add(dyn.elementAt(i).toString());
      }
      return converted;
    } catch (e) {
      return converted;
    }
  }

  Datar _extractDataResponse(decodedItem) {
    return Datar(
      extractAccountData(decodedItem['facebook_postit_user_data']),
      extractAccountData(decodedItem['twitter_postit_user_data']),
      extractAccountData(decodedItem['linked_in_postit_user_data']),
    );
  }

  List<AccountResponseData> extractAccountData(List<dynamic> accountData) {
    List<AccountResponseData> finalData = <AccountResponseData>[];
    if (accountData != null) {
      for (int counter = 0; counter < accountData.length; counter++) {
        finalData.add(AccountResponseData(
            accountData[counter]['username'],
            accountData[counter]['user_id'],
            accountData[counter]['access_token']));
      }
    }
    return finalData;
  }
}

class AccountResponseData {
  String username;
  String userId;
  String accessToken;
  bool checked = false;

  AccountResponseData(this.username, this.userId, this.accessToken);

/*factory FacebookResponseData.fromJson(Map<String, dynamic> data){
    return FacebookResponseData(data['username'], data['user_id'], data['access_token']);
  }*/
}

class Datar {
  List<AccountResponseData> facebook;
  List<AccountResponseData> twitter;
  List<AccountResponseData> linkedin;

  Datar(this.facebook, this.twitter, this.linkedin);
}
