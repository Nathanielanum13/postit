import 'package:angular_router/angular_router.dart';
import 'package:angular_app/src/route_paths.dart' as _parent;

class InnerRoutePaths {
  static final dash_home = RoutePath(path: 'dash_home', parent: _parent.RoutePaths.dashboard);
  static final create_post = RoutePath(path: 'create_post', parent: _parent.RoutePaths.dashboard);
  static final manage_post = RoutePath(path: 'manage_post', parent: _parent.RoutePaths.dashboard);
  static final view_post = RoutePath(path: 'view_post', parent: _parent.RoutePaths.dashboard);
  static final post_account = RoutePath(path: 'post_account', parent: _parent.RoutePaths.dashboard);
  static final user_account = RoutePath(path: 'user_account', parent: _parent.RoutePaths.dashboard);
  static final setting = RoutePath(path: 'setting', parent: _parent.RoutePaths.dashboard);
  static final facebook = RoutePath(path: 'facebook', parent: _parent.RoutePaths.dashboard);
  static final facebook_logout = RoutePath(path: 'facebook/logout', parent: _parent.RoutePaths.dashboard);
}
