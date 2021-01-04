import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/facebook_data_service.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'fb-app',
  templateUrl: 'fb_component.html',
  directives: [coreDirectives, routerDirectives],
  exports: [InnerRoutePaths, InnerRoutes],
  providers: [ClassProvider(FacebookDataService)],
)
class FbComponent extends OnActivate {
  String code;
  final Router _router;
  final FacebookDataService _facebookDataService;

  FbComponent(this._facebookDataService, this._router);

  @override
  Future<void> onActivate(RouterState previous, RouterState current) async {

    // Make sure the code parameter is not empty
    if (current.queryParameters['code'] == '') {
      print('Something went wrong');
      return;
    }

    // If it isn't empty store it in the code variable
    code = current.queryParameters['code'];
    print('Code: ${code}');

    // Send the code to the service to send the data
    var response = await _facebookDataService.sendCodeToApi(code);
    if (response.statusCode != 200) {
      return;
    }

    print('Json Response Body: ${json.decode(response.body)}');
//    var fbConfig = config['authentication']['facebook'];
//    var appId = fbConfig['appId'];
//    var url = fbConfig['url'];
//    var appSecret = fbConfig['appSecret'];
//
//    var link = 'https://graph.facebook.com/oauth/access_token?client_id=$appId&redirect_uri=$url&client_secret=$appSecret&code=$_code';
//    http.read(link).then((value) {
//      var uri = Uri.splitQueryString(value);
//      var acc = uri['access_token'];
//      print(acc);
//
//      http.read('https://graph.facebook.com/me?access_token=$acc').then((contents) {
//        var user =json.decode(contents);
//
//        print(user); // Logged in as this user.
//      });
//    });
    _router.navigate(InnerRoutePaths.post_account.toUrl());

  }
}
