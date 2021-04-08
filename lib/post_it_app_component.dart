import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/about_component/about_component.dart'
    deferred as a;
import 'package:angular_app/src/dashboard_component/dashboard_component.dart'
    deferred as d;
import 'package:angular_app/src/home_component/home_component.dart'
    deferred as h;
import 'package:angular_app/src/login_component/login_component.dart'
    deferred as l;
import 'package:angular_app/src/navbar_component/navbar_component.dart'
    deferred as nav;
import 'package:angular_app/src/not_found_component/not_found_component.dart'
    deferred as n;
import 'package:angular_app/src/routes.dart';
import 'package:angular_app/src/signup_component/signup_component.dart'
    deferred as s;
import 'package:angular_router/angular_router.dart';

@Component(
    selector: 'postit-app',
    styleUrls: ['post_it_app_component.css'],
    templateUrl: 'post_it_app_component.html',
    directives: [routerDirectives, coreDirectives],
    exports: [Routes])
class PostItAppComponent implements OnInit {
  @override
  Future<void> ngOnInit() async {
    var defaultAppTheme = AppTheme('bg-postit', 'bg-postit-one',
        'bg-postit-two', 'text-muted', 'text-dark');
    if (window.localStorage.containsKey('x-user-preference-theme')) {
      print('Welcome Back');
    } else {
      window.localStorage['x-user-preference-theme'] = json.encode({
        'box': defaultAppTheme.box,
        'box-one': defaultAppTheme.boxOne,
        'box-two': defaultAppTheme.boxTwo,
        'text-muted': defaultAppTheme.mutedColor,
        'text-colour': defaultAppTheme.textColour,
      });
    }
    print("Thank you for using POSTIT");
    await h.loadLibrary();
    await l.loadLibrary();
    await s.loadLibrary();
    await n.loadLibrary();
    await a.loadLibrary();
    await nav.loadLibrary();
  }
}

class AppTheme {
  String box;
  String boxOne;
  String boxTwo;
  String mutedColor;
  String textColour;

  AppTheme(
      this.box, this.boxOne, this.boxTwo, this.mutedColor, this.textColour);
}
