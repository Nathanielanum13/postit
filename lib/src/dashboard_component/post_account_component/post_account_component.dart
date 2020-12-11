import 'dart:html';
// import 'dart:io' as io show HttpServer, HttpRequest, InternetAddress, ContentType;
import 'package:angular_app/config.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'post-account',
  templateUrl: 'post_account_component.html',
  styleUrls: ['post_account_component.css'],
  directives: [routerDirectives, coreDirectives],
)
class PostAccountComponent implements OnInit {
  bool toggle = false;
  bool toggleView = false;
  String mediaName = '';
  String mediaIcon = '';
  String mediaText = '';
  bool isFinished = false;
  var loginLinkUrl = '';

  void setDefault() {
    var a = getDocument();
    if (a.getElementById('dialog').getAttribute('display') == 'true' &&
        isFinished) {
      print('bongo');
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

  Future<void> gotoFacebook() async {
    var fbConfig = config['authentication']['facebook'];
    var appId = fbConfig['appId'];
    var url = fbConfig['url'];

    loginLinkUrl =
        'https://www.facebook.com/dialog/oauth/?client_id=$appId&display=popup&redirect_uri=$url&state=TEST_TOKEN&scope=email';
    // _router.navigate(
    //     InnerRoutePaths.facebook.toUrl(parameters: {'loginurl': loginLinkUrl}));
  }

  @override
  Future<void> ngOnInit() async {
    gotoFacebook();
  }
}
