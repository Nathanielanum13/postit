import 'dart:async';
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

  bool isFetchingFbPosts = false;

  int insertPosition = 0;
  // ignore: cancel_subscriptions
  StreamSubscription<MouseEvent> listener;

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
    message = '@' + chats[index].issuer + '@ ';
    getDocument().getElementById('chat-area').focus();
    getDocument().getElementById('chat-area-mob').focus();
  }
  void like(Element element) {
    element.classes.toggle('text-primary');
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
      Timer(Duration(milliseconds: 100), closeEmojiContainer);
    } else {
      emojiElement.style.display = 'none';
      chatElement.style.position = 'fixed';
    }
  }
  void toggleEmojiContainerDesktop() {
    isEmojiClicked = !isEmojiClicked;
    var emojiElement = getDocument().getElementById('emojis-desktop');
    if(isEmojiClicked) {
      emojiElement.style.display = 'block';
      window.scroll(0, getDocument().getElementById('postit-body').scrollHeight);
    } else {
      emojiElement.style.display = 'none';
    }
  }

  void closeEmojiContainer() {
    listener = getDocument().getElementById('area-0').onClick.listen((event) {
      close();
    });
  }

  void close() {
    toggleEmojiContainer();
    listener.cancel();
  }

  void setData(data) {
    arrangePostMessage(data);
  }

  void arrangePostMessage(String emoValue) {
    List<String> postMessageList = <String>[];

    if (message.isNotEmpty) {
      for (int i = 0; i < message.length; i++) {
        postMessageList.add(message[i]);
      }
      postMessageList.insert(insertPosition, emoValue);
      insertPosition += 2;
    } else {
      /*postMessage = postMessage + emoValue;*/
      postMessageList.add(emoValue);
      insertPosition += 2;
    }

    message = '';

    for (int i = 0; i < postMessageList.length; i++) {
      message = message + postMessageList[i];
    }
  }

  void getInputSelection(InputElement el) {
    var endPosition = el.selectionEnd;
    insertPosition = endPosition;
  }

  @override
  Future<void> ngOnInit() async {
    // TODO: implement ngOnInit
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
    isFetchingFbPosts = true;
    engagements = await _getPostEngagementServices.getAllFacebookEngagements();
    isFetchingFbPosts = false;
    allPostEngagements = engagements.postEngagement;
  }

}