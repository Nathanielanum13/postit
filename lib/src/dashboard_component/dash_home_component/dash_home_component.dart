import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/websocket_service.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_app/variables.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_modern_charts/angular_modern_charts.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'dash-home',
  templateUrl: 'dash_home_component.html',
  styleUrls: ['dash_home_component.css'],
  directives: [
    MaterialProgressComponent,
    formDirectives,
    coreDirectives,
    PieChartComponent,
    routerDirectives,
    AlertComponent
  ],
  pipes: [commonPipes],
  providers: [ClassProvider(GetWebSocketData), ClassProvider(GetPostService)],
  exports: [InnerRoutes],
)
class DashHomeComponent implements OnInit, CanNavigate {
  DateTime date = DateTime.now();
  Router _router;
  Alert setAlert;
  bool deletePopup = false;
  int focusScheduleId = null;

  WebSocket webSocket;
  String currentSchedule = 'Current Schedule';
  int currentScheduleId;
  List<Post> sentPosts = <Post>[];
  CountDataType counters = CountDataType(0, 0, 0);
  List<Schedule> schedules = <Schedule>[];
  int postCount = 0;
  int scheduleCount = 0;
  List<int> active = <int>[];
  List<int> durationItems = <int>[];
  List<SocketData> datas = <SocketData>[];
  var appTheme;
  final GetWebSocketData _getWebSocketData;
  final GetPostService _getPostService;
  StreamSubscription<MouseEvent> listener;

  DashHomeComponent(this._getWebSocketData, this._router, this._getPostService);

  void togglePopup(int index) {
    deletePopup = !deletePopup;
    var dashHome = getDocument().getElementById('dash-home');
    if (deletePopup) {
      focusScheduleId = index;
      dashHome.style.filter = 'blur(3px)';
      Timer(Duration(milliseconds: 100), afterClose);
    } else {
      focusScheduleId = null;
      dashHome.style.filter = 'blur(0)';
    }
  }

  void afterClose() {
    var dashHome = getDocument().getElementById('dash-home');
    listener = dashHome.onClick.listen((event) {
      closePopup();
    });
  }

  void closePopup() {
    var dashHome = getDocument().getElementById('dash-home');
    deletePopup = false;
    dashHome.style.filter = 'blur(0)';
    listener.cancel();
  }

  void postData(int index) {
    currentSchedule = datas[index].scheduleTitle;
    sentPosts = datas[index].postedPosts;
    currentScheduleId = datas[index].totalPosts;
  }

  Future<void> gotoCreatePostComponent() async {
    _router.navigate(InnerRoutePaths.create_post.toUrl());
  }

  Future<void> gotoManagePostComponent() async {
    _router.navigate(InnerRoutePaths.manage_post.toUrl());
  }

  Future<void> gotoPostAccountComponent() async {
    _router.navigate(InnerRoutePaths.post_account.toUrl());
  }

  Future<void> deleteSchedule() async {
    var index = focusScheduleId;
    String id = schedules[index].id;
    try {
      PostStandardResponse deleteResponse =
          await _getPostService.deleteSchedule(id);
      setAlert =
          Alert(deleteResponse.data.message, deleteResponse.httpStatusCode);
      Timer(Duration(seconds: 5), resetAlert);

      if (deleteResponse.httpStatusCode == 200) {
        schedules.removeAt(index);
        closePopup();
      }
    } catch (e) {
      setAlert = Alert('Could not delete. Server error', 500);
      Timer(Duration(seconds: 5), resetAlert);
    }
  }

  void calculateProgress(int total, int posted) {
    active.add(((posted / total) * 100).toInt());
  }

  void calculateDuration() {
    for (int counter = 0; counter < schedules.length; counter++) {
      durationItems.add(DateTime.parse(schedules[counter].from)
          .difference(Date.today().asUtcTime())
          .inDays);
    }
  }

  void resetAlert() {
    setAlert = null;
  }

  void filterSchedule(String id) {
    for (int i = 0; i < schedules.length; i++) {
      if (schedules[i].id == id) {
        schedules.removeAt(i);
      }
    }
  }

  @override
  Future<void> ngOnInit() async {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
    counters = await _getWebSocketData.getCountData();
    schedules = await _getPostService.getAllScheduledPost();
    calculateDuration();
    if (counters.accountCount == 0) {
      setAlert = Alert('No account added. Add to proceed', 400);
    }
    /*init [webSocket] var with [WebSocket] object*/
    webSocket = WebSocket('${env['SCHEDULE_STATUS_WEBSOCKET']}');

    /* variable to store unencoded data for websocket handshake */
    Map userData;
    /* variable to store json encoded websocket handshake data */
    String data;
    /* send websocket handshake data when connection opens */
    webSocket.onOpen.first.then((_) => {
          userData = {
            'tenant_namespace': '${window.sessionStorage['tenant-namespace']}',
            'auth_token': '${window.sessionStorage['token']}'
          },
          data = json.encode(userData),
          webSocket.send(data)
        });

    // This code doesn't work so u can delete it if u want
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      print("connected to websocket");
    }

    /* listen for messages on the websocket */
    webSocket.onMessage.listen((MessageEvent event) {
      print(event.data);
      if (event.data == null) {
        webSocket.close();
      } else {
        datas = _getWebSocketData.extractSocketData(json.decode(event.data));
        for (int i = 0; i < datas.length; i++) {
          calculateProgress(datas[i].totalPosts, datas[i].postCount);
          filterSchedule(datas[i].scheduleId);
        }
      }
    });
  }

  @override
  Future<bool> canNavigate() async {
    try {
      print('closing socket ...');
      await webSocket.close();
      print('socket closed!');
    } catch (e) {
      print(e);
      return true;
    }
    return true;
  }
}
