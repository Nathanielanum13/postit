import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/variables.dart';
import 'package:http/http.dart';

@Injectable()
class GetPostEngagementServices {
  Client _http;
  var _headers = {
    'Content-type': 'application/json',
    'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
    'tenant-namespace': '${window.sessionStorage['tenant-namespace']}',
    'Authorization': 'Bearer ${window.sessionStorage['token']}'
  };

  static final _fbPostsUrl = '${env['FACEBOOK_POST_URL']}';

  GetPostEngagementServices(this._http);

  Future<Engagement> getAllFacebookEngagements() async {
    var resp;
    Engagement finalEngagement;
    try {
      resp = await _http.get(_fbPostsUrl, headers: _headers);
      finalEngagement =
          _extractFacebookEngagements(json.decode(resp.body)['data'] as List);
    } catch (e) {
      print('Some other error:: $e');
      return Engagement([]);
    }
    return finalEngagement;
  }

  Engagement _extractFacebookEngagements(data) {
    List<PostEngagement> finalPostEngagement = <PostEngagement>[];

    for (int counter = 0; counter < data.length; counter++) {
      finalPostEngagement.add(PostEngagement(
          data[counter]['facebook_post_id'], data[counter]['post_message']));
    }
    return Engagement(finalPostEngagement);
  }
}

Engagement getEngagements() {
  return Engagement(
    [
      PostEngagement('1', 'This is the first post',
          source: 'facebook',
          likes: 101,
          comments: 47,
          commentMessages: [
            Comment('1m', 'First comment1', 'receiver', 'Jerry Bobby',
                '24 Feb 2021 - 3:14pm'),
            Comment(
                '2m',
                'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ad, architecto delectus dignissimos eos esse et exercitationem inventore ipsa, iste itaque laborum, laudantium magni minima molestias qui sed soluta tempore voluptate',
                'sender',
                'Prince Bobby',
                '24 Feb 2021 - 3:14pm'),
            Comment(
                '3m',
                'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ad, architecto delectus dignissimos eos esse et exercitationem inventore ipsa, iste itaque laborum, laudantium magni minima molestias qui sed soluta tempore voluptate',
                'receiver',
                'Jerry Bobby',
                '24 Feb 2021 - 3:14pm'),
            Comment('4m', 'First comment4', 'sender', 'Prince Bobby',
                '24 Feb 2021 - 3:14pm'),
          ])
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

  List<Comment> commentMessages;

  PostEngagement(this.postId, this.postMessage,
      {this.source, this.likes, this.comments, this.commentMessages});
}

class Comment {
  String messageId;
  String message;
  String status;
  String issuer;
  String date;

  Comment(this.messageId, this.message, this.status, this.issuer, this.date);
}
