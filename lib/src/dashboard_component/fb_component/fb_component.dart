import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

@Component(selector: 'fb-app', templateUrl: 'fb_component.html')
class FbComponent extends OnActivate {
  @override
  void onActivate(_, RouterState current) {
    var code = current.queryParameters['code'];
    print('Code: ${code}');
  }
}
