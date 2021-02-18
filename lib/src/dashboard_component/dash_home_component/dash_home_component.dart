import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/websocket_service.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_modern_charts/angular_modern_charts.dart';

import 'package:angular_app/variables.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'dash-home',
  templateUrl: 'dash_home_component.html',
  styleUrls: ['dash_home_component.css'],
  directives: [
    GaugeChartComponent,
    MaterialProgressComponent,
    formDirectives,
    coreDirectives,
    PieChartComponent,
  ],
  pipes: [commonPipes],
  providers: [ClassProvider(GetWebSocketData)],
)

class DashHomeComponent implements OnInit, CanNavigate {
  DateTime date = DateTime.now();

  WebSocket webSocket;
  String currentSchedule = 'Current Schedule';
  List<Post> sentPosts = <Post>[
    Post(
      'This is the first message, I love this message soo much',
      postTag: ['wow', 'great', 'messy'],
    ),
    Post(
      'This is the second message, I love this message soo much',
      postTag: ['wow', 'great', 'messy'],
    ),
    Post(
      'This is the third message, I love this message soo much',
      postTag: ['wow', 'great', 'messy'],
    ),
  ];
  CountDataType counters = CountDataType(0, 0, 0);

  int postCount = 0;
  int scheduleCount = 0;
  List<int> active = <int>[];
  List<SocketData> datas = <SocketData>[];

  final GetWebSocketData _getWebSocketData;
  DashHomeComponent(this._getWebSocketData);

  void postData(int index) {
    currentSchedule = datas[index].scheduleTitle;
  }

  void calculateProgress(int total, int posted) {
    active.add(((posted/total)*100).toInt());
  }

  @override
  Future<void> ngOnInit() async {
    counters = await _getWebSocketData.getCountData();

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
      data =  json.encode(userData),
      webSocket.send(data)
    });

    // This code doesn't work so u can delete it if u want
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      print("connected to websocket");
    }

    /* listen for messages on the websocket */
    webSocket.onMessage.listen((MessageEvent event) {
      print(event.data);
      if(event.data == null) {
        webSocket.close();
      } else {
        datas = _getWebSocketData.extractSocketData(json.decode(event.data));
        for(int i = 0; i < datas.length; i++) {
          calculateProgress(datas[i].totalPosts, datas[i].postCount);
        }
      }
    });
  }

  @override
  Future<bool> canNavigate() async {
    try{
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
