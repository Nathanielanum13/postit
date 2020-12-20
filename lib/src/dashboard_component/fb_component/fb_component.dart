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
  @override
  void onActivate(_, RouterState current) {
    print("Found fb component");
    var code = current.queryParameters['code'];
    print('Code: ${code}');
  }
}
