import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'fb-app',
  templateUrl: 'fb_component.html',
  directives: [coreDirectives],
  exports: [InnerRoutePaths, InnerRoutes]
)
class FbComponent extends OnActivate {
  String code = '';
  @override
  void onActivate(_, RouterState current) {
    if (current.queryParameters['code'] == '') {
      print('Somethig went wrong');
      return;
    }
    code = current.queryParameters['code'];
    print('Code: ${code}');
  }
}
