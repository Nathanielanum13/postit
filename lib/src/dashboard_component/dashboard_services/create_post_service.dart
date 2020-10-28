import 'dart:async';
import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:http/http.dart';

@Injectable()
class GetPostService {
  static final _headers = {'Content-type': 'application/json'};
  static const _postUrl = 'https://postit-backend-api.herokuapp.com/posts';
  static final _scheduleUrl = 'https://postit-backend-api.herokuapp.com/schedule-post';

  final Client _http;

  GetPostService(this._http);

  Future<List<Post>> getAllPost() async {
    try {
      final response = await _http.get(_postUrl);
      final posts = (_extractPostData(response) as List)
          .map((json) => Post.fromJson(json))
          .toList();
      return posts;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Schedule>> getAllScheduledPost() async {
    try {
      final response = await _http.get(_scheduleUrl);
      final schedules = (_extractPostData(response) as List)
          .map((json) => Schedule.fromJson(json))
          .toList();
      return schedules;
    } catch (e) {
      throw _handleError(e);
    }
  }

//  Emoji _extractEmoji(Response r) {
//    var decodedJson = json.decode(r.body);
//    return Emoji(
//      emoticons: convertLDS(decodedJson['emoticons']),
//      ding_bats: convertLDS(decodedJson['ding_bats']),
//      transport: convertLDS(decodedJson['transport']),
//      un_categorized: convertLDS(decodedJson['un_categorized']),
//      enclosed_characters: convertLDS(decodedJson['enclosed_characters']),
//    );
//  }

  dynamic _extractPostData(Response resp) => json.decode(resp.body)['data'];

  PostStandardResponse _extractData(Response resp) {
    var httpStatusCode = resp.statusCode;
    var decodedData = json.decode(resp.body)['data'];
//    var decodedMeta = json.decode(resp.body)['meta'];

    Data data = Data('', '');
//    Meta meta = Meta(
//        timestamp: '',
//        transactionId: '',
//        traceId: '',
//        status: ''
//    );
    data.id = decodedData['id'];
    data.message = decodedData['ui_message'];
//    meta.timestamp = decodedMeta['timestamp'];
//    meta.transactionId = decodedMeta['transaction_id'];
//    meta.traceId = decodedMeta['trace_id'];
//    meta.status = decodedMeta['status'];
    return PostStandardResponse(data: data, httpStatusCode: httpStatusCode);
  }

  Exception _handleError(dynamic e) {
    print(e); // for demo purposes only
    return Exception('Server error; cause: $e');
  }

  Future<PostStandardResponse> create(
      String message, {List<String> tags, List<int> image, bool priority}) async {
    try {
      final response = await _http.post(_postUrl,
          headers: _headers,
          body: json.encode({
            'post_message': message,
            'hash_tags': tags,
            'post_image': image,
            'post_priority': priority,
          }));
      return _extractData(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostStandardResponse> createSchedule(
      String title, String from, String to, List<String> postIds) async {
    try {
      final response = await _http.post(_scheduleUrl,
          headers: _headers,
          body: json.encode({
            'schedule_title': title,
            'from': from,
            'to': to,
            'post_ids': postIds,
          }));
      return _extractData(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostStandardResponse> update(
      String id, String message, List<String> tags, List<int> image) async {
    try {
      final update_response = await _http.put(_postUrl + '?post_id=' + id,
          headers: _headers,
          body: json.encode({
            'post_message': message,
            'hash_tags': tags,
            'post_image': image,
          }));
      return _extractData(update_response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostStandardResponse> delete(String id) async {
    try {
      final deleteResponse = await _http.delete(_postUrl + '?post_id=' + id);
      return _extractData(deleteResponse);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostStandardResponse> deleteSchedule(String id) async {
    try {
      final deleteResponse =
          await _http.delete(_scheduleUrl + '?schedule_id=' + id);
      return _extractData(deleteResponse);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostStandardResponse> batchDelete(List<String> ids) async {
    final _batchDeleteUrl = 'http://localhost:5379/batch-delete';
    try {
      final deleteResponse = await _http.post(_batchDeleteUrl,
          headers: _headers, body: json.encode({'post_ids': ids}));
      return _extractData(deleteResponse);
    } catch (e) {
      throw _handleError(e);
    }
  }

//  Future<Emoji> getEmojis() async {
//    final _emojisUrl = 'http://localhost:5379/emoji';
//    try {
//      final emojiStruct = await _http.get(_emojisUrl);
//      return _extractEmoji(emojiStruct);
//    } catch(e) {
//      throw _handleError(e);
//    }
//  }

  Future<List<Post>> getAllCurrentPost() async => await currentDBPost();
}

class Post {
  String id;
  String postMessage;
  List<String> postTag;
  List<int> postImage;
  String postPic;
  String createdOn;
  bool checkedState = false;
  bool postPriority;

  Post(this.postMessage,
      {this.postTag,
      this.postImage,
      this.id,
      this.postPic,
      this.createdOn,
      this.postPriority});

  factory Post.fromJson(Map<String, dynamic> post) {
//    post['hash_tags'] = convertLDS(post['hash_tags']);
    return Post(
      post['post_message'],
      postTag: convertLDS(post['hash_tags']),
      postPic: post['post_image'],
      id: post['post_id'],
      createdOn: post['created_on'],
    );
  }

  Map toJson() => {
        'post_message': postMessage,
        'hash_tags': postTag,
        'post_image': postImage,
        'id': id
      };
}

List<Post> currentDBPost() {
  List<Post> dbPost = <Post>[];
  return dbPost;
}

//class Emoji {
//  List<String> emoticons;
//  List<String> ding_bats;
//  List<String> transport;
//  List<String> un_categorized;
//  List<String> enclosed_characters;
//
//  Emoji({this.emoticons, this.ding_bats, this.transport, this.un_categorized, this.enclosed_characters});
//}

List<String> convertLDS(List<dynamic> dyn) {
  List<String> converted = <String>[];
  try {
    print(dyn.length);
    for (int i = 0; i < dyn.length; i++) {
      converted.add(dyn.elementAt(i).toString());
    }
    return converted;
  } catch (e) {
    converted = ['No tags'];
    return converted;
  }
}

class Schedule {
  String title;
  String from;
  String to;
  String id;
  String created_on;
  String updated_on;

  Schedule(this.title, this.from, this.to,
      {this.created_on, this.updated_on, this.id});

  factory Schedule.fromJson(Map<String, dynamic> schedule) {
    return Schedule(
      schedule['schedule_title'],
      schedule['from'],
      schedule['to'],
      id: schedule['schedule_id'],
    );
  }
  Map toJson() => {
    'schedule_title': title,
    'from': from,
    'to': to,
    'schedule_id': id
  };
}
