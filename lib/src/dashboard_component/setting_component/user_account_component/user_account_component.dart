import 'dart:html';
import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/setting_component/settings_service/settings_service.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'user-account',
  templateUrl: 'user_account_component.html',
  styleUrls: ['user_account_component.css'],
  directives: [coreDirectives, formDirectives],
  providers: [ClassProvider(SettingsService)],
)
class UserAccountComponent implements OnInit {
  final SettingsService _settingsService;

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

  UserAccountComponent(this._settingsService);

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
    final data = json.decode(window.sessionStorage['x-data']);
    companyName = data['company_name'];
    companyAddress = data['company_address'];
//    companyPhoneNumber = data['company_contact_number'];
    companyEmail = data['company_email'];
    profile = Profile(
        username: data['username'],
        firstName: data['admin_first_name'],
        lastName: data['admin_last_name']);
  }
}
