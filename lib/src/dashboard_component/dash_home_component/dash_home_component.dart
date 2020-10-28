import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_modern_charts/angular_modern_charts.dart';

@Component(
  selector: 'dash-home',
  templateUrl: 'dash_home_component.html',
  styleUrls: ['dash_home_component.css'],
  directives: [GaugeChartComponent],

  providers: [ClassProvider(GetPostService)],
)
class DashHomeComponent implements OnInit{
  List<Post> posts = <Post>[];
  List<String> newPost = <String>[];

  void getNewPost() {
    for(int i = 0; i < posts.length; i++) {
      List<String> createdOn = posts[i].createdOn.split('T');
      createdOn.removeLast();

      Date createdDate = Date.fromTime(DateTime.parse(createdOn[0]));

      if(createdDate.isOnOrAfter(Date.today().subtract(days: 1))) {
        newPost.add(posts[i].id);
      }
    }
  }

  final GetPostService _getPostService;
  DashHomeComponent(this._getPostService);

  @override
  Future<void> ngOnInit() async {
    // TODO: implement ngOnInit
    posts = await _getPostService.getAllPost();
    getNewPost();
  }

}
