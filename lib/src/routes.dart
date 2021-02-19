import 'package:angular_app/src/home_component/home_component.template.dart' as home_template;
import 'package:angular_app/src/dashboard_component/dashboard_component.template.dart' as dashboard_template;
import 'package:angular_app/src/about_component/about_component.template.dart' as about_template;
import 'package:angular_app/src/login_component/login_component.template.dart' as login_template;
import 'package:angular_app/src/signup_component/signup_component.template.dart' as signup_template;
import 'package:angular_app/src/not_found_component/not_found_component.template.dart' as not_found_template;
import 'package:angular_router/angular_router.dart';
import 'route_paths.dart' as rp;
export 'route_paths.dart';

class Routes {
  static final home = RouteDefinition(
    routePath: rp.RoutePaths.home,
    component: home_template.HomeComponentNgFactory,
    useAsDefault: true,
  );
  static final about = RouteDefinition(
    routePath: rp.RoutePaths.about,
    component: about_template.AboutComponentNgFactory,
  );
  static final login = RouteDefinition(
    routePath: rp.RoutePaths.login,
    component: login_template.LoginComponentNgFactory,
  );

  static final signup = RouteDefinition(
    routePath: rp.RoutePaths.signup,
    component: signup_template.SignupComponentNgFactory,
  );

  static final dashboard = RouteDefinition(
    routePath: rp.RoutePaths.dashboard,
    component: dashboard_template.DashboardComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    home,
    about,
    login,
    dashboard,
    signup,
    RouteDefinition(
      path: '.+',
      component: not_found_template.NotFoundComponentNgFactory,
    ),
  ];
}