import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/inner_route_paths.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'setting-app',
  templateUrl: 'setting_component.html',
  styleUrls: ['setting_component.css'],
  directives: [routerDirectives],
  exports: [InnerRoutePaths, InnerRoutes]
)
class SettingComponent {

}
