import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/post_engagement_services.dart';
import 'package:angular_app/src/dashboard_component/widgets/emojis_component/emojis_component.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'post-engagement',
  templateUrl: 'post_engagement_component.html',
  styleUrls: ['post_engagement_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    EmojisComponent,
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
  bool isEmojiClicked = false;
  var appTheme;

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
  void replyComment(int index) {
    message = '@' + chats[index].issuer + ' ';
    getDocument().getElementById('chat-area').focus();
  }
  void like(Element element) {
    element.setAttribute('class', 'fa fa-thumbs-up text-primary');
  }

  void autoScroll() {
    var element = getDocument().getElementById('chat-box');
    element.scrollTop = element.scrollHeight;

    var element1 = getDocument().getElementById('chat-box-mob');
    element1.scrollTop = element1.scrollHeight;
  }

  void toggleEmojiContainer() {
    isEmojiClicked = !isEmojiClicked;
    var emojiElement = getDocument().getElementById('emojis');
    var chatElement = getDocument().getElementById('chat-engine');
    if(isEmojiClicked) {
      emojiElement.style.display = 'block';
      chatElement.style.position = 'relative';
      window.scroll(0, getDocument().getElementById('postit-body').scrollHeight);
    } else {
      emojiElement.style.display = 'none';
      chatElement.style.position = 'fixed';
    }
  }

  @override
  Future<void> ngOnInit() async {
    // TODO: implement ngOnInit
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
    engagements = await _getPostEngagementServices.getAllEngagements();
    allPostEngagements = engagements.postEngagement;
  }

}