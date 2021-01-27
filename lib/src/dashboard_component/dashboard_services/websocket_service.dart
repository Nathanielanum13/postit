import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';

@Injectable()
class GetWebSocketData {
  Future<List<SocketData>> GetSocketData() async {
    return Data();
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
  bool isSelected = false;

  SocketData(
      this.scheduleId,
      this.scheduleTitle,
      this.from,
      this.to,
      this.totalPosts,
      this.postCount,
      this.postedPosts,
      this.isSelected
      );
}
List<SocketData> Data() {
  return [
    SocketData(
      '1',
      'A',
      '12-02-21',
      '13-02-21',
      10,
      12,
      [
        Post('post 1'),
        Post('Wow'),
        Post('post 2')
      ],
      false
    ),
    SocketData(
      '2',
      'B',
      '12-02-21',
      '13-02-21',
      1,
      2,
        [
          Post('post a1'),
          Post('Wow a'),
          Post('post a2')
        ],
      false
    )
  ];
}