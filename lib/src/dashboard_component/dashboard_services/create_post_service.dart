import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_app/variables.dart';
import 'package:http/http.dart';

@Injectable()
class GetPostService {
  var _headers = {
    'Content-type': 'application/json',
    'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
    'tenant-namespace': '${window.sessionStorage['tenant-namespace']}',
    'Authorization': 'Bearer ${window.sessionStorage['token']}'
  };
  static final _postUrl = '${env['POST_URL']}';
  static final _scheduleUrl = '${env['SCHEDULE_URL']}';
  static final _batchDeleteUrl = '${env['BATCH_DELETE_URL']}';

  final Client _http;

  GetPostService(this._http);

  Future<List<Post>> getAllPost() async {
    try {
      final response = await _http.get(_postUrl, headers: _headers);
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
      final response = await _http.get(_scheduleUrl, headers: _headers);
      final schedules = (_extractPostData(response) as List)
          .map((json) => Schedule.fromJson(json))
          .toList();
      return schedules;
    } catch (e) {
      return [];
    }
  }

  dynamic _extractPostData(Response resp) => json.decode(resp.body)['data'];

  PostStandardResponse _extractData(Response resp) {
    var httpStatusCode = resp.statusCode;
    var decodedData = json.decode(resp.body)['data'];

    Data data = Data(decodedData['id'], decodedData['ui_message']);
    return PostStandardResponse(data: data, httpStatusCode: httpStatusCode);
  }

  Exception _handleError(ExceptionHandler e) {
    return Exception('Server error; cause: ${e.toString()}');
  }

  Future<PostStandardResponse> create(String message,
      {List<String> tags, List<int> image, bool priority}) async {
    try {
      Post po = Post(message, postTag: tags, postPriority: priority);

      final response = await _http.post(_postUrl,
          headers: _headers, body: json.encode(po.toJson()));
      return _extractData(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostStandardResponse> createSchedule(
      String title,
      bool postToFeed,
      String from,
      String to,
      List<String> postIds,
      List<String> fbIds,
      List<String> twIds,
      List<String> liIds) async {
    try {
      Schedule schedule = Schedule(title, from, to,
          postIds: postIds,
          fbAccounts: fbIds,
          twAccounts: twIds,
          liAccounts: liIds);
      final response = await _http.post(_scheduleUrl,
          headers: _headers, body: json.encode(schedule.toJson()));
      return _extractData(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostStandardResponse> update(
      String id, String message, List<String> tags, {List<String> image}) async {
    try {
      Post po = Post(message, postTag: tags);
      final update_response = await _http.put(_postUrl + '?post_id=' + id,
          headers: _headers, body: json.encode(po.toJson()));
      return _extractData(update_response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostStandardResponse> delete(String id) async {
    try {
      final deleteResponse =
          await _http.delete(_postUrl + '?post_id=' + id, headers: _headers);
      return _extractData(deleteResponse);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<PostStandardResponse> deleteSchedule(String id) async {
    var deleteResponse;
    try {
      deleteResponse = await _http.delete(_scheduleUrl + '?schedule_id=' + id,
          headers: _headers);
    } catch (e) {
      throw _handleError(e);
    }
    return _extractData(deleteResponse);
  }

  Future<PostStandardResponse> batchDelete(List<String> ids) async {
    try {
      final deleteResponse = await _http.post(_batchDeleteUrl,
          headers: _headers, body: json.encode({'post_ids': ids}));
      return _extractData(deleteResponse);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Post>> getAllCurrentPost() async => await currentDBPost();
}

class Post {
  String id;
  String postMessage;
  List<String> postTag;
  List<String> postImage;
  List<String> imagePaths;
  String postPic;
  String createdOn;
  bool checkedState = false;
  bool postPriority;
  bool postStatus;
  bool scheduleStatus;
  bool edit = false;
  bool fbStatus;
  bool twStatus;
  bool liStatus;

  Post(this.postMessage,
      {this.postTag,
      this.postImage,
      this.id,
      this.postPic,
      this.createdOn,
      this.postPriority,
      this.postStatus,
      this.scheduleStatus,
      this.fbStatus,
      this.twStatus,
      this.liStatus,
      this.imagePaths});

  factory Post.fromJson(Map<String, dynamic> post) {
    return Post(post['post_message'],
        postTag: convertLDS(post['hash_tags']),
        postPic: post['post_image'],
        id: post['post_id'],
        createdOn: post['created_on'],
        fbStatus: post['post_fb_status'],
        twStatus: post['post_tw_status'],
        liStatus: post['post_li_status'],
        scheduleStatus: post['scheduled'],
        postImage: convertLDS(post['post_images']),
        imagePaths: convertLDS(post['image_paths']),);
  }

  Map toJson() => {
        'post_message': postMessage,
        'hash_tags': postTag,
      };
}

List<Post> currentDBPost() {
  List<Post> dbPost = <Post>[];
  return dbPost;
}

List<String> convertLDS(List<dynamic> dyn) {
  List<String> converted = <String>[];
  try {
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
  bool postToFeed;
  String created_on;
  String updated_on;
  List<String> postIds;
  int duration;
  List<String> fbAccounts;
  List<String> twAccounts;
  List<String> liAccounts;

  Schedule(this.title, this.from, this.to,
      {this.created_on,
      this.postToFeed,
      this.updated_on,
      this.id,
      this.postIds,
      this.duration,
      this.fbAccounts,
      this.twAccounts,
      this.liAccounts});

  factory Schedule.fromJson(Map<String, dynamic> schedule) {
    return Schedule(
      schedule['schedule_title'],
      schedule['from'],
      schedule['to'],
      id: schedule['schedule_id'],
      postIds: convertLDS(schedule['post_ids']),
    );
  }

  Map toJson() => {
        'schedule_title': title,
        'post_to_feed': postToFeed,
        'from': from,
        'to': to,
        'post_ids': postIds,
        'profiles': {
          'facebook': fbAccounts,
          'twitter': twAccounts,
          'linked_in': liAccounts,
        },
      };
}
