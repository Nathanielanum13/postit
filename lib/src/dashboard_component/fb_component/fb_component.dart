import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/config.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/facebook_data_service.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_router/angular_router.dart';
import 'package:http/http.dart' as http;

@Component(
  selector: 'fb-app',
  templateUrl: 'fb_component.html',
  directives: [coreDirectives, routerDirectives],
  exports: [InnerRoutePaths, InnerRoutes],
  providers: [ClassProvider(FacebookDataService)],
)
class FbComponent extends OnActivate {
  String _code;
  final Router _router;
  final FacebookDataService _facebookDataService;

  FbComponent(this._facebookDataService, this._router);

  @override
  Future<void> onActivate(RouterState previous, RouterState current) async {

    if (current.queryParameters['code'] == '') {
      print('Something went wrong');
      return;
    }

    _code = current.queryParameters['code'];
    print('Code: ${_code}');

    var response = await _facebookDataService.sendCodeToApi(_code);
    if (response.statusCode != 200) {
      return;
    }

    print('Json Response Body: ${json.decode(response.body)}');

    var fbConfig = config['authentication']['facebook'];
    var appId = fbConfig['appId'];
    var url = fbConfig['url'];
    var appSecret = fbConfig['appSecret'];

    var link = 'https://graph.facebook.com/oauth/access_token?client_id=$appId&redirect_uri=$url&client_secret=$appSecret&code=$_code';
    http.read(link).then((value) {
      var uri = Uri.splitQueryString(value);
      var acc = uri['access_token'];
      print(acc);
    });

    _router.navigate(InnerRoutePaths.post_account.toUrl());

  }
}
