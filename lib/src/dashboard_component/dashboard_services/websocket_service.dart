import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/variables.dart';
import 'package:http/http.dart';

@Injectable()
class GetWebSocketData {
  var _headers = {
    'Content-type': 'application/json',
    'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
    'tenant-namespace': '${window.sessionStorage['tenant-namespace']}',
    'Authorization': 'Bearer ${window.sessionStorage['token']}'
  };

  static final _countUrl = '${env['COUNT_URL']}';

  Client _http;
  List<SocketData> finalSocket = <SocketData>[];
  GetWebSocketData(this._http);

  List<SocketData> extractSocketData(List<dynamic> data) {
    List<SocketData> finalData = <SocketData>[];

    try {
      for(int i = 0; i < data.length; i++) {
        finalData.add(
            SocketData(
                data[i]['schedule_id'],
                data[i]['schedule_title'],
                data[i]['from'],
                data[i]['to'],
                data[i]['total_post'],
                data[i]['post_count'],
                convertDynamicToListOfPost(data[i]['posts'])
            )
        );
      }
    } catch (e){
      return finalData;
    }
    return finalData;
  }
  Future<CountDataType> getCountData() async {
    try {
      final resp = await _http.get(_countUrl, headers: _headers);
      return _extractCountData(resp);
    } catch(e) {
      throw _handleError(e);
    }
  }

  CountDataType _extractCountData(Response resp) {
    var data = json.decode(resp.body);
    return CountDataType(data['post_count'], data['schedule_count'], data['account_count']);
  }

  Exception _handleError(dynamic e) {
    return Exception('Server error; cause: $e');
  }

  List<Post> convertDynamicToListOfPost(List<dynamic> allPosts) {
    List<Post> finalPost = [];
    if(allPosts != null) {
      for(int i = 0; i < allPosts.length; i++) {
        finalPost.add(
            Post(
                allPosts[i]['post_message'],
                postTag: convertLDS(allPosts[i]['hash_tags']),
                postImage: convertDynamicToListOfInt(allPosts[i]['post_image']),
                id: allPosts[i]['post_id'],
                postStatus: allPosts[i]['post_status']
            )
        );
      }
    } else {
      return finalPost;
    }
    return finalPost;
  }

  List<int> convertDynamicToListOfInt(List<dynamic> imageBytes) {
    List<int> finalImageBytes = [];
    if(imageBytes.isNotEmpty) {
      for(int i = 0; i < imageBytes.length; i++) {
        finalImageBytes.add(imageBytes[i]);
      }
    } else {
      return finalImageBytes;
    }
    return finalImageBytes;
  }
}
class SocketData {
  String scheduleId;
  String scheduleTitle;
  String from;
  String to;
  int totalPosts;
  int postCount;
  List<Post> postedPosts;

  SocketData(
      this.scheduleId,
      this.scheduleTitle,
      this.from,
      this.to,
      this.totalPosts,
      this.postCount,
      this.postedPosts
      );
}

class CountDataType {
  int postCount;
  int scheduleCount;
  int accountCount;

  CountDataType(
      this.postCount,
      this.scheduleCount,
      this.accountCount
      );
}