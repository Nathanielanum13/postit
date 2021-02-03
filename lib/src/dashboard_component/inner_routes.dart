import 'package:angular_app/src/dashboard_component/create_post_component/create_post_component.template.dart' as create_post_template;
import 'package:angular_app/src/dashboard_component/view_post_component/view_post_component.template.dart' as view_post_template;
import 'package:angular_app/src/dashboard_component/manage_post_component/manage_post_component.template.dart' as manage_post_template;
import 'package:angular_app/src/dashboard_component/dash_home_component/dash_home_component.template.dart' as dash_home_template;
import 'package:angular_app/src/dashboard_component/post_account_component/post_account_component.template.dart' as post_account_template;
import 'package:angular_app/src/dashboard_component/post_engagement_component/post_engagement_component.template.dart' as post_engagement_template;
import 'package:angular_app/src/dashboard_component/setting_component/user_account_component/user_account_component.template.dart' as user_account_template;
import 'package:angular_app/src/dashboard_component/setting_component/setting_component.template.dart' as setting_template;
import 'package:angular_app/src/dashboard_component/fb_component/fb_component.template.dart' as facebook_template;
import 'package:angular_app/src/dashboard_component/fb_delete_component/fb_delete_component.template.dart' as facebook_logout_template;
import 'package:angular_router/angular_router.dart';
import 'inner_route_paths.dart';
export 'inner_route_paths.dart';

class InnerRoutes {
  static final dash_home = RouteDefinition(
    routePath: InnerRoutePaths.dash_home,
    component: dash_home_template.DashHomeComponentNgFactory,
    useAsDefault: true,
  );
  static final create_post = RouteDefinition(
    routePath: InnerRoutePaths.create_post,
    component: create_post_template.CreatePostComponentNgFactory,
  );
  static final view_post = RouteDefinition(
    routePath: InnerRoutePaths.view_post,
    component: view_post_template.ViewPostComponentNgFactory,
  );
  static final manage_post = RouteDefinition(
    routePath: InnerRoutePaths.manage_post,
    component: manage_post_template.ManagePostComponentNgFactory,
  );
  static final post_account = RouteDefinition(
    routePath: InnerRoutePaths.post_account,
    component: post_account_template.PostAccountComponentNgFactory,
  );
  static final post_engagement = RouteDefinition(
    routePath: InnerRoutePaths.post_engagement,
    component: post_engagement_template.PostEngagementComponentNgFactory,
  );
  static final user_account = RouteDefinition(
    routePath: InnerRoutePaths.user_account,
    component: user_account_template.UserAccountComponentNgFactory,
  );
  static final setting = RouteDefinition(
    routePath: InnerRoutePaths.setting,
    component: setting_template.SettingComponentNgFactory,
  );
  static final facebook = RouteDefinition(
    routePath: InnerRoutePaths.facebook,
    component: facebook_template.FbComponentNgFactory,
  );

  static final facebook_logout = RouteDefinition(
    routePath: InnerRoutePaths.facebook_logout,
    component: facebook_logout_template.FbDeleteComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    dash_home,
    create_post,
    view_post,
    manage_post,
    post_account,
    post_engagement,
    user_account,
    setting,
    facebook,
    facebook_logout,
  ];
}