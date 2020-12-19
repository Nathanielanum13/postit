import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_modern_charts/angular_modern_charts.dart';

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
  List<Post> posts = <Post>[];
  List<Schedule> scheduledPosts = <Schedule>[];
  DateTime date = DateTime.now();
  String postCreated = '';
  String postScheduled = '';
  int activeProgress = 10;


  final GetPostService _getPostService;
  DashHomeComponent(this._getPostService);

  @override
  Future<void> ngOnInit() async {
    // TODO: implement ngOnInit
    posts = await _getPostService.getAllPost();
    scheduledPosts = await _getPostService.getAllScheduledPost();

    if(posts.length > 1) {
      postCreated = 'Posts';
    } else if(posts.length <= 1) {
      postCreated = 'Post';
    }
    if(scheduledPosts.length > 1) {
      postScheduled = 'Posts';
    } else if(scheduledPosts.length <= 1) {
      postScheduled = 'Post';
    }
  }

}
