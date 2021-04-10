import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/facebook_data_service.dart';
import 'package:angular_app/src/dashboard_component/inner_route_paths.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_app/src/dashboard_component/setting_component/settings_service/settings_service.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'setting-app',
  templateUrl: 'setting_component.html',
  styleUrls: ['setting_component.css'],
  directives: [
    routerDirectives,
    coreDirectives,
    formDirectives,
    AlertComponent,
    MaterialCheckboxComponent,
    MaterialToggleComponent
  ],
  providers: [
    ClassProvider(SettingsService),
    ClassProvider(FacebookDataService)
  ],
  exports: [InnerRoutePaths, InnerRoutes],
)
class SettingComponent implements OnInit {
  final SettingsService _settingsService;
  final FacebookDataService _facebookDataService;
  Router _router;

  // User Profile
  Profile profile = Profile(username: "", firstName: "", lastName: "");

  // Login details
  String oldPassword = '';
  String newPassword = '';

  // Company details
  String companyName = '';
  String companyAddress = '';
  String companyPhoneNumber = '';
  String companyEmail = '';
  bool search = false;
  bool isLoading = false;
  bool darkMode = false;
  bool isDone = false;

  String activeAccount = '';
  int activeAccountIndex;
  List<AccountResponseData> activeAccountLists = <AccountResponseData>[];

  int fbCount = 0;
  int twCount = 0;
  int liCount = 0;
  Datar data;
  var appTheme;
  Theme darkTheme = Theme('bg-dark', 'Dark', 'bg-dark-one', 'bg-dark-two', textColor: 'text-white', mutedText: 'dark-text-muted', borderState: 'border-0', table: 'table-dark');
  Alert setAlert;

  SettingComponent(
      this._settingsService, this._facebookDataService, this._router);

  void displaySearch() {
    search = !search;
  }

  void resetAlert() {
    setAlert = null;
  }

  void toggleDarkMode() {
    // Show dialog
    !darkMode;
    if (darkMode) {
      getDocument().getElementById('settings-app').style.filter =
          'blur(3px) brightness(0.9)';
      Timer(Duration(seconds: 1), neutralizer);
      // Update user preference data ^^^^^^^

    } else {
      isDone = false;
      getDocument().getElementById('settings-app').style.filter =
          'blur(0) brightness(1)';
      darkTheme = Theme('bg-postit', 'Postit', 'bg-postit-one', 'bg-postit-two', textColor: 'text-dark', mutedText: 'text-muted', table: 'table-light');
      applyTheme();
      refresh();
    }
  }

  void applyTheme() {
    window.localStorage['x-user-preference-theme'] = json.encode(
        {
          'box' : darkTheme.className,
          'box-one' : darkTheme.classNameOne,
          'box-two' : darkTheme.classNameTwo,
          'text-muted' : darkTheme.mutedText,
          'text-colour' : darkTheme.textColor,
          'border' : darkTheme.borderState,
          'table' : darkTheme.table,
        }
    );
    refresh();
  }

  Future<void> refresh() async {
    _router.navigate(InnerRoutePaths.dash_home.toUrl());
  }

  void neutralizer() {
    isDone = true;
    getDocument().getElementById('settings-app').style.filter =
        'blur(0) brightness(1)';
    applyTheme();
  }

  Future<void> gotoPostAccount() async {
    _router.navigate(InnerRoutePaths.post_account.toUrl());
  }

  void disable(int index) {}

  Future<void> saveProfile() async {
    profile.username = profile.username.trim();
    profile.firstName = profile.firstName.trim();
    profile.lastName = profile.lastName.trim();

    if (profile.username.isEmpty ||
        profile.firstName.isEmpty ||
        profile.lastName.isEmpty) {
      return;
    }

    try {
      await _settingsService.saveProfile(profile);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveLoginDetails() async {
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      return;
    }

    try {
      await _settingsService.saveLoginDetails(oldPassword, newPassword);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveCompanyDetails() async {
    if (companyName.isEmpty ||
        companyAddress.isEmpty ||
        companyPhoneNumber.isEmpty ||
        companyEmail.isEmpty) {
      return;
    }

    try {
      await _settingsService.saveCompanyDetails(
          companyName, companyAddress, companyPhoneNumber, companyEmail);
    } catch (e) {
      print(e);
    }
  }

  @override
  void ngOnInit() {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
    if (appTheme['box'] == 'bg-dark') {
      darkMode = !darkMode;
      isDone = true;
    } else darkMode = false;
    final data = json.decode(window.sessionStorage['x-data']);
    companyName = data['company_name'];
    companyAddress = data['company_address'];
//    companyPhoneNumber = data['company_contact_number'];
    companyEmail = data['company_email'];
    profile = Profile(
        username: data['username'],
        firstName: data['admin_first_name'],
        lastName: data['admin_last_name']);

    getAccountData();
  }

  Future<void> getAccountData() async {
    try {
      isLoading = true;
      data = await _facebookDataService.getAllAccountData();
      isLoading = false;
      fbCount = data.facebook.length;
      twCount = data.twitter.length;
      liCount = data.linkedin.length;
    } catch (e) {
      isLoading = false;
    }
  }

  void setAccounts(int index) {
    switch (index) {
      case 0:
        getFacebookAccounts(index);
        break;
      case 1:
        getLinkedinAccounts(index);
        break;
      case 2:
        getTwitterAccounts(index);
        break;
    }
  }

  void getFacebookAccounts(int index) {
    activeAccount = 'Facebook';
    activeAccountIndex = index;
    activeAccountLists = data.facebook;
  }

  void getTwitterAccounts(int index) {
    activeAccount = 'Twitter';
    activeAccountIndex = index;
    activeAccountLists = data.twitter;
  }

  void getLinkedinAccounts(int index) {
    activeAccount = 'Linkedin';
    activeAccountIndex = index;
    activeAccountLists = data.linkedin;
  }
}
class Theme {
  String className;
  String themeName;
  String classNameOne;
  String classNameTwo;
  String mutedText;
  String textColor;
  String borderState;
  String table;

  Theme(this.className, this.themeName, this.classNameOne, this.classNameTwo, {this.mutedText, this.textColor, this.borderState, this.table});
}
