import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/facebook_data_service.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'fb-app',
  templateUrl: 'fb_delete_component.html',
  directives: [coreDirectives, routerDirectives],
  exports: [InnerRoutePaths, InnerRoutes],
  providers: [ClassProvider(FacebookDataService)],
)
class FbDeleteComponent extends OnActivate {
  final Router _router;
  final FacebookDataService _facebookDataService;

  FbDeleteComponent(this._facebookDataService, this._router);

  @override
  Future<void> onActivate(RouterState previous, RouterState current) async {
    _router.navigate(InnerRoutePaths.post_account.toUrl());

  }
}
