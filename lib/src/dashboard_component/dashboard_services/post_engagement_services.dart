import 'package:angular/angular.dart';
import 'dart:async';

@Injectable()
class GetPostEngagementServices {
  Future<Engagement> getAllEngagements() async => getEngagements();
}
Engagement getEngagements() {
  return Engagement(
    [
      PostEngagement('1', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ad, architecto delectus dignissimos eos esse et exercitationem inventore ipsa, iste itaque laborum, laudantium magni minima molestias qui sed soluta tempore voluptate.', 'facebook', 10, 3, 2,
        [
          Comment('1m', 'First comment1', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
          Comment('2m', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ad, architecto delectus dignissimos eos esse et exercitationem inventore ipsa, iste itaque laborum, laudantium magni minima molestias qui sed soluta tempore voluptate', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
          Comment('3m', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ad, architecto delectus dignissimos eos esse et exercitationem inventore ipsa, iste itaque laborum, laudantium magni minima molestias qui sed soluta tempore voluptate', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
          Comment('4m', 'First comment4', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
        ]
      ),
      PostEngagement('1', 'Ghana is free forever2', 'facebook', 1, 7, 2,
          [
            Comment('1m', 'Second comment1', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('2m', 'Second comment2', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('3m', 'Second comment3', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('4m', 'Second comment4', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('5m', 'Second comment5', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('6m', 'Second comment6', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('7m', 'Second comment7', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
          ]
      ),
      PostEngagement('1', 'Ghana is free forever3', 'facebook', 3, 2, 5,
          [
            Comment('1m', 'third comment1', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('2m', 'third comment2', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
          ]
      ),
      PostEngagement('1', 'Ghana is free forever2', 'facebook', 1, 7, 2,
          [
            Comment('1m', 'Second comment1', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('2m', 'Second comment2', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('3m', 'Second comment3', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('4m', 'Second comment4', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('5m', 'Second comment5', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('6m', 'Second comment6', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('7m', 'Second comment7', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
          ]
      ),
      PostEngagement('1', 'Ghana is free forever2', 'facebook', 1, 7, 2,
          [
            Comment('1m', 'Second comment1', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('2m', 'Second comment2', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('3m', 'Second comment3', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('4m', 'Second comment4', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('5m', 'Second comment5', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('6m', 'Second comment6', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('7m', 'Second comment7', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
          ]
      ),
      PostEngagement('1', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ad, architecto delectus dignissimos eos esse et exercitationem inventore ipsa, iste itaque laborum, laudantium magni minima molestias qui sed soluta tempore voluptate.', 'facebook', 10, 3, 2,
          [
            Comment('1m', 'First comment1', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('2m', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ad, architecto delectus dignissimos eos esse et exercitationem inventore ipsa, iste itaque laborum, laudantium magni minima molestias qui sed soluta tempore voluptate', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('3m', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ad, architecto delectus dignissimos eos esse et exercitationem inventore ipsa, iste itaque laborum, laudantium magni minima molestias qui sed soluta tempore voluptate', 'receiver', 'Jerry Bobby', '24 Feb 2021 - 3:14pm'),
            Comment('4m', 'First comment4', 'sender', 'Prince Bobby', '24 Feb 2021 - 3:14pm'),
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
  String date;

  Comment(
      this.messageId,
      this.message,
      this.status,
      this.issuer,
      this.date
      );
}