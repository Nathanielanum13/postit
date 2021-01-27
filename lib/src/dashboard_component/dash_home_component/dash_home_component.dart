import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/websocket_service.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
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
    formDirectives,
    coreDirectives
  ],
  pipes: [commonPipes],
  providers: [ClassProvider(GetPostService), ClassProvider(GetWebSocketData)],
)
class DashHomeComponent implements OnInit{
  DateTime date = DateTime.now();

  String currentSchedule = 'Current Schedule';
  List<Post> sentPosts = [];
  int activeProgress = 10;

  int postCount = 0;
  int scheduleCount = 0;
  List<SocketData> data = [];


  final GetPostService _getPostService;
  final GetWebSocketData _getWebSocketData;
  DashHomeComponent(this._getPostService, this._getWebSocketData);

  void postData(int index) {
    currentSchedule = data[index].scheduleTitle;
    sentPosts = data[index].postedPosts;
  }

  @override
  Future<void> ngOnInit() async {
    data = await _getWebSocketData.GetSocketData();
    postCount = await _getPostService.getPostCount();
    scheduleCount = await _getPostService.getScheduleCount();
  }

}