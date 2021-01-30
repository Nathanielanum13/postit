import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/websocket_service.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_modern_charts/angular_modern_charts.dart';

import 'package:angular_app/variables.dart';

@Component(
  selector: 'dash-home',
  templateUrl: 'dash_home_component.html',
  styleUrls: ['dash_home_component.css'],
  directives: [
    GaugeChartComponent,
    MaterialProgressComponent,
    formDirectives,
    coreDirectives
  ],
  pipes: [commonPipes],
  providers: [ClassProvider(GetWebSocketData)],
)
class DashHomeComponent implements OnInit{
  DateTime date = DateTime.now();

  WebSocket webSocket;
  String currentSchedule = 'Current Schedule';
  List<Post> sentPosts = <Post>[];
  CountDataType counters = CountDataType(0, 0, 0);
  int activeProgress = 10;

  int postCount = 0;
  int scheduleCount = 0;
  List<SocketData> datas = <SocketData>[];

  final GetWebSocketData _getWebSocketData;
  DashHomeComponent(this._getWebSocketData);

  void postData(int index) {
    currentSchedule = datas[index].scheduleTitle;
    sentPosts = datas[index].postedPosts;
  }

  void see() {
    print('God is Good ${datas.toString()}');
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
        'tenant_namespace': '${window.localStorage['tenant-namespace']}',
        'auth_token': '${window.localStorage['token']}'
      },
      data =  json.encode(userData),
      webSocket.send(data)
    });

    // This code doesn't work so u can delete it if u want
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN){
      print("connected to websocket");
    }

    /* listen for messages on the websocket */
    webSocket.onMessage.listen((MessageEvent event) {
      print(event.data);

      if(event.data == null) {
        webSocket.close();
      } else {
        datas = _getWebSocketData.extractSocketData(json.decode(event.data));
      }
    }
    );
  }

}