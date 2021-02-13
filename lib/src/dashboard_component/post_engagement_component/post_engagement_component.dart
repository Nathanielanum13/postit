import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/post_engagement_services.dart';
import 'package:angular_components/utils/browser/window/module.dart';

@Component(
  selector: 'post-engagement',
  templateUrl: 'post_engagement_component.html',
  styleUrls: ['post_engagement_component.css'],
  directives: [
    coreDirectives,
  ],
  providers: [ClassProvider(GetPostEngagementServices)],
)
class PostEngagementComponent implements OnInit{
  GetPostEngagementServices _getPostEngagementServices;
  bool chatShow = false;
  Engagement engagements;
  List<PostEngagement> allPostEngagements = <PostEngagement>[];
  List<Comment> chats = <Comment>[];

  PostEngagementComponent(this._getPostEngagementServices);
  void showChat() {
    chatShow = !chatShow;
  }
  void hideChat() {
    chatShow = false;
  }
  void loadChat(int index) {
    chats = allPostEngagements[index].commentMessages;
  }

  @override
  Future<void> ngOnInit() async {
    // TODO: implement ngOnInit
    engagements = await _getPostEngagementServices.getAllEngagements();
    allPostEngagements = engagements.postEngagement;
  }
}