import 'dart:convert';
import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../inner_route_paths.dart';
import '../../inner_routes.dart';

@Component(
  selector: 'not-found-app',
  templateUrl: 'theme_component.html',
  styleUrls: ['theme_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    routerDirectives
  ],
  exports: [InnerRoutes, InnerRoutePaths],
)
class ThemeComponent implements OnInit {
  int selectedTheme;
  var appTheme;
  Router _router;
  List<Theme> themes = <Theme>[
    Theme('bg-postit', 'Postit', 'bg-postit-one', 'bg-postit-two', textColor: 'text-dark', mutedText: 'text-muted'),
    Theme('bg-dark', 'Dark', 'bg-dark-one', 'bg-dark-two', textColor: 'text-white', mutedText: 'dark-text-muted'),
    Theme('bg-primary', 'Blue', 'bg-primary-one', 'bg-primary-two', textColor: 'text-white', mutedText: 'dark-text-muted'),
    Theme('bg-success', 'Green', 'bg-success-one', 'bg-success-two', textColor: 'text-white', mutedText: 'dark-text-muted'),
    Theme('bg-danger', 'Red', 'bg-danger-one', 'bg-danger-two'),
    Theme('bg-info', 'Blue green', 'bg-info-one', 'bg-info-two', textColor: 'text-white', mutedText: 'dark-text-muted'),
    Theme('bg-antiquewhite', 'Antiquewhite', 'bg-antiquewhite-one', 'bg-antiquewhite-two', textColor: 'text-dark', mutedText: 'text-muted'),
    Theme('bg-navy', 'Navy', 'bg-navy-one', 'bg-navy-two', textColor: 'text-white', mutedText: 'dark-text-muted'),
    Theme('bg-pink', 'Pink', 'bg-pink-one', 'bg-pink-two'),
    Theme('bg-aqua', 'Aqua', 'bg-aqua-one', 'bg-aqua-two'),
    Theme('bg-skyblue', 'Skyblue', 'bg-skyblue-one', 'bg-skyblue-two'),
    Theme('bg-warning', 'Yellow', 'bg-warning-one', 'bg-warning-two'),
  ];

  ThemeComponent(this._router);

  void preview(int index) {
    selectedTheme = index;
    getDocument().getElementById('preview-box').setAttribute('class', 'preview-box ${themes[index].classNameTwo}');
    getDocument().getElementById('p-nav').setAttribute('class', 'p-nav ${themes[index].classNameOne}');
    getDocument().getElementById('p-side').setAttribute('class', 'p-side mt-2 ${themes[index].className}');
  }
  Future<void> refresh() async {
    _router.navigate(InnerRoutePaths.setting.toUrl());
  }
  void applyTheme() {
    window.localStorage['x-user-preference-theme'] = json.encode(
        {
          'box' : themes[selectedTheme].className,
          'box-one' : themes[selectedTheme].classNameOne,
          'box-two' : themes[selectedTheme].classNameTwo,
          'text-muted' : themes[selectedTheme].mutedText,
          'text-colour' : themes[selectedTheme].textColor,
        }
    );
    refresh();
  }

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
  }
}
class Theme {
  String className;
  String themeName;
  String classNameOne;
  String classNameTwo;
  String mutedText;
  String textColor;

  Theme(this.className, this.themeName, this.classNameOne, this.classNameTwo, {this.mutedText, this.textColor});
}