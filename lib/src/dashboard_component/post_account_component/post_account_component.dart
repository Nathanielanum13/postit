import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/facebook_data_service.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_app/config.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'post-account',
  templateUrl: 'post_account_component.html',
  styleUrls: ['post_account_component.css'],
  directives: [
    coreDirectives,
    routerDirectives,
  ],
  providers: [ClassProvider(FacebookDataService)],
)
class PostAccountComponent implements OnInit {
  bool toggle = false;
  bool toggleView = false;
  String mediaName = '';
  String mediaIcon = '';
  String mediaText = '';
  bool isFinished = false;
  String loginLinkUrl = '';
  int accountCount = 0;
  List<String> accountEmails = <String>[];
  final FacebookDataService _facebookDataService;

  PostAccountComponent(this._facebookDataService);

  void setDefault() {
    var a = getDocument();
    if (a.getElementById('dialog').getAttribute('display') == 'true' &&
        isFinished) {
    } else {
      return;
    }
  }

  void cancel() {
    toggle = true;
    showPopup('');
  }

  void cancelView() {
    toggleView = true;
    showViewPopup('');
  }

  void showPopup(String name) {
    toggle = !toggle;
    var doc = getDocument();
    List<Element> a = doc.querySelectorAll('#body button');

    if (toggle) {
      doc.getElementById('dialog').setAttribute('display', 'true');
      doc.getElementById('view-dialog').setAttribute('display', 'false');
      doc.getElementById('body').style.filter = 'blur(5px)';

      for (int i = 0; i < a.length; i++) {
        a[i].setAttribute('disabled', 'true');
      }

      if (name == 'facebook') {
        mediaName = 'Facebook';
        mediaIcon = 'facebook';
        mediaText = 'text-primary';
      } else if (name == 'twitter') {
        mediaName = 'Twitter';
        mediaIcon = 'twitter';
        mediaText = 'text-primary';
      } else if (name == 'instagram') {
        mediaName = 'Instagram';
        mediaIcon = 'instagram';
        mediaText = 'text-danger';
      } else if (name == 'linkedin') {
        mediaName = 'LinkedIn';
        mediaIcon = 'linkedin';
        mediaText = 'text-primary';
      }
    } else {
      doc.getElementById('dialog').setAttribute('display', 'false');
      doc.getElementById('view-dialog').setAttribute('display', 'false');
      doc.getElementById('body').style.filter = 'blur(0px)';
      mediaIcon = '';

      for (int i = 0; i < a.length; i++) {
        a[i].removeAttribute('disabled');
      }
    }
  }

  void showViewPopup(String name) {
    toggleView = !toggleView;
    var doc = getDocument();
    List<Element> a = doc.querySelectorAll('#body button');

    if (toggleView) {
      doc.getElementById('view-dialog').setAttribute('display', 'true');
      doc.getElementById('dialog').setAttribute('display', 'false');
      doc.getElementById('body').style.filter = 'blur(5px)';

      for (int i = 0; i < a.length; i++) {
        a[i].setAttribute('disabled', 'true');
      }

      if (name == 'facebook') {
        mediaName = 'Facebook';
      } else if (name == 'twitter') {
        mediaName = 'Twitter';
      } else if (name == 'instagram') {
        mediaName = 'Instagram';
      } else if (name == 'linkedin') {
        mediaName = 'LinkedIn';
      }
    } else {
      doc.getElementById('view-dialog').setAttribute('display', 'false');
      doc.getElementById('dialog').setAttribute('display', 'false');
      doc.getElementById('body').style.filter = 'blur(0px)';

      for (int i = 0; i < a.length; i++) {
        a[i].removeAttribute('disabled');
      }
    }
  }

  void gotoFacebook() {
    var fbConfig = config['authentication']['facebook'];
    var appId = fbConfig['appId'];
    var url = fbConfig['url'];

    loginLinkUrl = 'https://www.facebook.com/v9.0/dialog/oauth/?response_type=token&display=popup&client_id=$appId&redirect_uri=$url&state=access_token&scope=pages_read_engagement';
  }

  @override
  Future<void> ngOnInit() async {
    await gotoFacebook();
    try {
      List<String> usernames = await _facebookDataService.getAllFacebookData();
      accountEmails = usernames;
      print('Account Emails: $accountEmails');
      accountCount = accountEmails.length;
    } catch (e){
      print('An error has occurred');
    }
  }
}
