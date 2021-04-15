import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/config.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/facebook_data_service.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'post-account',
  templateUrl: 'post_account_component.html',
  styleUrls: ['post_account_component.css'],
  directives: [coreDirectives, routerDirectives],
  providers: [ClassProvider(FacebookDataService)],
)
class PostAccountComponent implements OnInit {
  bool isFinished = false;
  String loginLinkUrl = '';
  var appTheme;
  Datar accounts;
  List<bool> accountTabs = [false, false, false, false];
  List<bool> viewTabs = [false, false, false, false];
  int fbCount = 0;
  int twCount = 0;
  int liCount = 0;

  StreamSubscription<MouseEvent> listener;
  final FacebookDataService _facebookDataService;

  PostAccountComponent(this._facebookDataService);

  Future<void> deleteFacebookAccount(int index) async {
    await _facebookDataService
        .deleteFacebookAccount(accounts.facebook[index].userId);
    var next = logout['next'];
    var accessToken = accounts.facebook[index].accessToken;
    var fbUrl =
        'https://www.facebook.com/logout.php?confirm=1&next=$next&access_token=$accessToken';

    window.location.assign(fbUrl);
  }

  Future<void> deleteTwitterAccount(int index) async {
    await _facebookDataService
        .deleteFacebookAccount(accounts.twitter[index].userId);
    var next = logout['next'];
    var accessToken = accounts.twitter[index].accessToken;
    var fbUrl =
        'https://www.facebook.com/logout.php?confirm=1&next=$next&access_token=$accessToken';

    window.location.assign(fbUrl);
  }

  Future<void> deleteLinkedinAccount(int index) async {
    await _facebookDataService
        .deleteFacebookAccount(accounts.linkedin[index].userId);
    var next = logout['next'];
    var accessToken = accounts.linkedin[index].accessToken;
    var fbUrl =
        'https://www.facebook.com/logout.php?confirm=1&next=$next&access_token=$accessToken';

    window.location.assign(fbUrl);
  }

  void afterClose() {
    var doc = getDocument().getElementById('post-app');
    listener = doc.onClick.listen((event) {
      closePopup();
    });
  }

  void closePopup() {
    var doc = getDocument().getElementById('post-app');
    doc.style.filter = 'blur(0)';
    btnState('enable');
    accountTabs = [false, false, false, false];
    viewTabs = [false, false, false, false];
    listener.cancel();
  }

  void btnState(String action) {
    var doc = getDocument();
    List<Element> a = doc.querySelectorAll('button.in');
    switch (action) {
      case 'enable':
        for (int i = 0; i < a.length; i++) {
          a[i].removeAttribute('disabled');
        }
        break;
      case 'disable':
        for (int i = 0; i < a.length; i++) {
          a[i].setAttribute('disabled', 'true');
        }
        break;
    }
  }

  void showPopup(int index) {
    accountTabs[index] = !accountTabs[index];
    var doc = getDocument();

    if (accountTabs[index]) {
      doc.getElementById('post-app').style.filter = 'blur(5px)';
      for (int counter = 0; counter < accountTabs.length; counter++) {
        if (counter == index) {
          continue;
        } else {
          accountTabs[counter] = false;
        }
      }
      btnState('disable');
      Timer(Duration(milliseconds: 100), afterClose);
    } else {
      closePopup();
      btnState('enable');
    }
  }

  void showViewPopup(int index) {
    viewTabs[index] = !viewTabs[index];
    var doc = getDocument();

    if (viewTabs[index]) {
      doc.getElementById('post-app').style.filter = 'blur(5px)';

      for (int counter = 0; counter < viewTabs.length; counter++) {
        if (counter == index) {
          continue;
        } else {
          viewTabs[counter] = false;
        }
      }
      btnState('disable');
      Timer(Duration(milliseconds: 100), afterClose);
    } else {
      closePopup();
      btnState('enable');
    }
  }

  void gotoFacebook() {
    var fbConfig = config['authentication']['facebook'];
    var appId = fbConfig['appId'];
    var url = fbConfig['url'];

    loginLinkUrl = 'https://www.facebook.com/v9.0/dialog/oauth/?display=popup&client_id=$appId&redirect_uri=$url&state=access_token&scope=pages_manage_posts,pages_read_engagement,pages_show_list,pages_manage_engagement,pages_read_user_content';
  }

  /*void loginWithFacebook() {
    var ref = window.open('$loginLinkUrl', 'account-login', 'status = 1, height = 600, width = 600, resizable = 0');
    print('::${ref.location.toString()}');
  }*/

  @override
  Future<void> ngOnInit() async {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
    await gotoFacebook();

    try {
      accounts = await _facebookDataService.getAllAccountData();
      fbCount = accounts.facebook.length;
      twCount = accounts.twitter.length;
      liCount = accounts.linkedin.length;
    } catch (e) {
      print('An error has occurred');
    }
  }
}
