import 'dart:html';
import 'dart:convert';
import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/setting_component/settings_service/settings_service.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_app/src/signup_component/signup_services.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'user-account',
  templateUrl: 'user_account_component.html',
  styleUrls: ['user_account_component.css'],
  directives: [coreDirectives, formDirectives, AlertComponent],
  providers: [ClassProvider(SettingsService)],
)
class UserAccountComponent implements OnInit {
  final SettingsService _settingsService;

  Alert setAlert;
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
      StandardResponse standardResponse =
          await _settingsService.saveProfile(profile);
      setAlert = Alert(standardResponse.message, standardResponse.statusCode);
      var data = json.decode(window.sessionStorage['x-data']);
      Map newD = {
        'admin_first_name': profile.firstName,
        'admin_last_name': profile.lastName,
        'username': profile.username,
        'password': data['password'],
        'company_name': data['company-name'],
        'company_website': data['company-website'],
        'company_address': data['company-address'],
        'company_contact_number': data['company_contact_number'],
        'company_email': data['company_email'],
        'ghana_post_address': data['ghana_post_address'],
      };
      window.sessionStorage.remove('x-data');
      window.sessionStorage['x-data'] = json.encode(newD);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveLoginDetails() async {
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      setAlert = Alert("old Password/new Password empty", 400);
      return;
    }

    try {
      StandardResponse standardResponse =
          await _settingsService.saveLoginDetails(oldPassword, newPassword);
      setAlert = Alert(standardResponse.message, standardResponse.statusCode);
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveCompanyDetails() async {
    if (companyName.isEmpty ||
        companyAddress.isEmpty ||
        companyPhoneNumber.isEmpty ||
        companyEmail.isEmpty) {
      setAlert = Alert("some 'Company Details' fields are empty", 400);
      return;
    }

    try {
      print('sending req');
      StandardResponse standardResponse =
          await _settingsService.saveCompanyDetails(
              companyName, companyAddress, companyPhoneNumber, companyEmail);
      setAlert = Alert(standardResponse.message, standardResponse.statusCode);
      var data = json.decode(window.sessionStorage['x-data']);
      Map newD = {
        'admin_first_name': data['admin_first_name'],
        'admin_last_name': data['admin_last_name'],
        'username': data['username'],
        'company_name': companyName,
        'company_website': data['company-website'],
        'company_address': companyAddress,
        // 'company_contact_number': companyPhoneNumber,
        'company_email': companyEmail,
        'ghana_post_address': data['ghana_post_address'],
        'created_at': data['created_at'],
        'updated_at': data['updated_at'],
      };
      window.sessionStorage.remove('x-data');
      window.sessionStorage['x-data'] = json.encode(newD);
    } catch (e) {
      print(e);
    }
  }

  @override
  void ngOnInit() {
    try {
      final data = json.decode(window.sessionStorage['x-data']);
      companyName = data['company_name'];
      companyAddress = data['company_address'];
      companyEmail = data['company_email'];
      profile = Profile(
          username: data['username'],
          firstName: data['admin_first_name'],
          lastName: data['admin_last_name']);
    } catch (e) {
      print(e);
      setAlert = Alert("Something went wrong! Contact admin", 400);
    }
  }
}
