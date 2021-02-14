import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/post_engagement_services.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'post-engagement',
  templateUrl: 'post_engagement_component.html',
  styleUrls: ['post_engagement_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
  ],
  providers: [ClassProvider(GetPostEngagementServices)],
)
class PostEngagementComponent implements OnInit{
  GetPostEngagementServices _getPostEngagementServices;
  bool chatShow = false;
  Engagement engagements;
  List<PostEngagement> allPostEngagements = <PostEngagement>[];
  List<Comment> chats = <Comment>[];
  String message = '';

  PostEngagementComponent(this._getPostEngagementServices);
  void showChat(int index) {
    chatShow = !chatShow;
    loadChat(index);
  }
  void hideChat() {
    chatShow = false;
  }
  void loadChat(int index) {
    chats = allPostEngagements[index].commentMessages;
  }
  void sendComment() {
    message.trim();

    if(message.isEmpty) {
      return;
    }

    chats.add(
      Comment('1', message, 'sender', 'Nathaniel Anum Adjah', DateTime.now().toLocal().toString())
    );

    message = '';
    autoScroll();
  }

  void autoScroll() {
    var element = getDocument().getElementById('chat-box');
    element.scrollTop = element.scrollHeight;
  }

  @override
  Future<void> ngOnInit() async {
    // TODO: implement ngOnInit
    engagements = await _getPostEngagementServices.getAllEngagements();
    allPostEngagements = engagements.postEngagement;
  }

}