import 'package:angular/angular.dart';
import 'dart:async';

@Injectable()
class GetPostEngagementServices {
  Future<Engagement> getAllEngagements() async => getEngagements();
}
Engagement getEngagements() {
  return Engagement(
    [
      PostEngagement('1', 'Ghana is free forever1', 'facebook', 10, 3, 2,
        [
          Comment('1m', 'First comment1', 'receiver', 'Jerry Bobby'),
          Comment('2m', 'First comment2', 'sender', 'Prince Bobby'),
          Comment('3m', 'First comment3', 'receiver', 'Jerry Bobby'),
          Comment('4m', 'First comment4', 'sender', 'Prince Bobby'),
        ]
      ),
      PostEngagement('1', 'Ghana is free forever2', 'facebook', 1, 7, 2,
          [
            Comment('1m', 'Second comment1', 'receiver', 'Jerry Bobby'),
            Comment('2m', 'Second comment2', 'sender', 'Prince Bobby'),
            Comment('3m', 'Second comment3', 'receiver', 'Jerry Bobby'),
            Comment('4m', 'Second comment4', 'sender', 'Prince Bobby'),
            Comment('5m', 'Second comment5', 'sender', 'Prince Bobby'),
            Comment('6m', 'Second comment6', 'receiver', 'Jerry Bobby'),
            Comment('7m', 'Second comment7', 'receiver', 'Jerry Bobby'),
          ]
      ),
      PostEngagement('1', 'Ghana is free forever3', 'facebook', 3, 2, 5,
          [
            Comment('1m', 'third comment1', 'receiver', 'Jerry Bobby'),
            Comment('2m', 'third comment2', 'sender', 'Prince Bobby'),
          ]
      ),
      PostEngagement('1', 'Ghana is free forever2', 'facebook', 1, 7, 2,
          [
            Comment('1m', 'Second comment1', 'receiver', 'Jerry Bobby'),
            Comment('2m', 'Second comment2', 'sender', 'Prince Bobby'),
            Comment('3m', 'Second comment3', 'receiver', 'Jerry Bobby'),
            Comment('4m', 'Second comment4', 'sender', 'Prince Bobby'),
            Comment('5m', 'Second comment5', 'sender', 'Prince Bobby'),
            Comment('6m', 'Second comment6', 'receiver', 'Jerry Bobby'),
            Comment('7m', 'Second comment7', 'receiver', 'Jerry Bobby'),
          ]
      ),
      PostEngagement('1', 'Ghana is free forever2', 'facebook', 1, 7, 2,
          [
            Comment('1m', 'Second comment1', 'receiver', 'Jerry Bobby'),
            Comment('2m', 'Second comment2', 'sender', 'Prince Bobby'),
            Comment('3m', 'Second comment3', 'receiver', 'Jerry Bobby'),
            Comment('4m', 'Second comment4', 'sender', 'Prince Bobby'),
            Comment('5m', 'Second comment5', 'sender', 'Prince Bobby'),
            Comment('6m', 'Second comment6', 'receiver', 'Jerry Bobby'),
            Comment('7m', 'Second comment7', 'receiver', 'Jerry Bobby'),
          ]
      ),
    ],
  );
}
class Engagement {
  List<PostEngagement> postEngagement;
  Engagement(this.postEngagement);
}
class PostEngagement {
  String postId;
  String postMessage;
  String source;
  int likes;
  int comments;
  int loves;

  List<Comment> commentMessages;

  PostEngagement(
      this.postId,
      this.postMessage,
      this.source,
      this.likes,
      this.comments,
      this.loves,
      this.commentMessages
      );
}
class Comment {
  String messageId;
  String message;
  String status;
  String issuer;

  Comment(
      this.messageId,
      this.message,
      this.status,
      this.issuer
      );
}