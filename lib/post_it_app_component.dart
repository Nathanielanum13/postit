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
    print("Thank you for using POSTIT");
  }
}

