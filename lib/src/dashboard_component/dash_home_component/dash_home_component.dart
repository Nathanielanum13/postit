import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_modern_charts/angular_modern_charts.dart';
import 'package:angular_app/variables.dart';
import 'dart:html';

@Component(
  selector: 'dash-home',
  templateUrl: 'dash_home_component.html',
  styleUrls: ['dash_home_component.css'],
  directives: [
    GaugeChartComponent,
    MaterialProgressComponent,
  ],
  pipes: [commonPipes],
  providers: [ClassProvider(GetPostService)],
)
class DashHomeComponent implements OnInit{
  DateTime date = DateTime.now();
  String postCreated = 'Post';
  String postScheduled = 'Post';
  int activeProgress = 10;

  int postCount = 0;
  int scheduleCount = 0;
  List<SchedulePost> socketArray = <SchedulePost>[];


  final GetPostService _getPostService;
  DashHomeComponent(this._getPostService);

  @override
  Future<void> ngOnInit() async {
    postCount = await _getPostService.getPostCount();
    scheduleCount = await _getPostService.getScheduleCount();

    var webSocket = WebSocket('${env['SCHEDULE_STATUS_WEBSOCKET']}');

    Map userData;
    String data;
    webSocket.onOpen.first.then((_) => {
      userData = {
        'tenant-namespace': '${window.localStorage['tenant-namespace']}',
        'auth-token': '${window.localStorage['token']}'
      },
      data = json.encode(userData),
      webSocket.send(data)
    });

    // This code doesn't work so u can delete it if u want
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN){
      print("connected to websocket");
    }

    webSocket.onMessage.listen((MessageEvent event) {
      print(event.data);
    });
  }

}
class SchedulePost {
  String scheduleId;
  String scheduleTitle;
  String from;
  String to;
  List<String> postIds;
  List<Post> posts;
  int postCount;

  SchedulePost(
      this.scheduleId,
      this.scheduleTitle,
      this.from,
      this.to,
      this.postIds,
      this.posts,
      this.postCount
      );
}