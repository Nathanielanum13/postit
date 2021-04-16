import 'dart:convert';
import 'dart:html';

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
class FbComponent extends OnActivate implements OnInit {
  String code;
  final Router _router;
  final FacebookDataService _facebookDataService;
  var appTheme;

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

    // Send the code to the service to send the data
    var response = await _facebookDataService.sendCodeToApi(code);
    if (response.statusCode != 200) {
      return;
    }

    _router.navigate(InnerRoutePaths.post_account.toUrl());

  }

  @override
  void ngOnInit() {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
  }
}
