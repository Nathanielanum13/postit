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

class DashHomeComponent implements OnInit, CanNavigate, AfterViewInit {
  List<ChartDataGauge> chartData = <ChartDataGauge>[
    ChartDataGauge(10.toDouble(), 90.toDouble())
  ];
  DateTime date = DateTime.now();

  var gaugeData;
  var gaugeProperties;

  WebSocket webSocket;
  String currentSchedule = 'Current Schedule';
  List<Post> sentPosts = <Post>[];
  CountDataType counters = CountDataType(0, 0, 0);

  int postCount = 0;
  int scheduleCount = 0;
  List<int> active = <int>[20];
  List<SocketData> datas = <SocketData>[
    SocketData('01', 'January', '23-02-2021', '24-02-2021', 25, 15, [
      Post('Indeed, Shiftr is Great', postTag: ['ShiftrGh', 'PostitForReal']),
      Post('We build and test business solutions', postTag: ['ShiftrGh', 'PostitForReal']),
      Post('Call us on 0505265215 or 0509131631', postTag: ['ShiftrGh', 'PostitForReal']),
    ])
  ];
  var appTheme;

  final GetWebSocketData _getWebSocketData;
  DashHomeComponent(this._getWebSocketData);


  void postData(int index) {
    currentSchedule = datas[index].scheduleTitle;
    sentPosts = datas[index].postedPosts;
  }

  void calculateProgress(int total, int posted) {
    active.add(((posted/total)*100).toInt());
  }

  @override
  Future<void> ngOnInit() async {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
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

  @override
  void ngAfterViewInit() {
    gaugeData = GaugeChartData(
      [
        GaugeChartColumnData('Posted', chartData[0].posted),
        GaugeChartColumnData('Pending', chartData[0].pending),
      ]
    );
    gaugeProperties = GaugeChartProperties()..height = '170px';
  }
}
class ChartDataGauge{
  double posted;
  double pending;
  ChartDataGauge(this.posted, this.pending);
}