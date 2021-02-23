import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/routes.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'postit-app',
  styleUrls: ['post_it_app_component.css'],
  templateUrl: 'post_it_app_component.html',
  directives: [routerDirectives, coreDirectives],
  exports: [Routes]
)
class PostItAppComponent implements OnInit {
  @override
  Future<void> ngOnInit() async {
    var defaultAppTheme = AppTheme('bg-postit', 'bg-postit-one', 'bg-postit-two', 'text-muted', 'text-dark');
    if(window.localStorage.containsKey('x-user-preference-theme')) {
      print('Welcome Back');
    } else {
      window.localStorage['x-user-preference-theme'] = json.encode(
        {
          'box' : defaultAppTheme.box,
          'box-one' : defaultAppTheme.boxOne,
          'box-two' : defaultAppTheme.boxTwo,
          'text-muted' : defaultAppTheme.mutedColor,
          'text-colour' : defaultAppTheme.textColour,
        }
      );
    }
    print("Thank you for using POSTIT");
  }
}
class AppTheme {
  String box;
  String boxOne;
  String boxTwo;
  String mutedColor;
  String textColour;

  AppTheme(this.box, this.boxOne, this.boxTwo, this.mutedColor, this.textColour);
}

