//import 'dart:convert';
//import 'dart:html';
//
//import 'package:angular/angular.dart';
//import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
//import 'dart:async';
//import 'package:http/http.dart';
//
//@Injectable()
//class GetScheduleService {
//  static final _headers = {'Content-type': 'application/json'};
//
//  final Client _http;
//  GetScheduleService(this._http);
//
//
//  PostStandardResponse _extractData(Response resp) {
//    var httpStatusCode = resp.statusCode;
//    var decodedData = json.decode(resp.body)['data'];
//
//    Data data = Data('', '');
//    data.id = decodedData['id'];
//    data.message = decodedData['ui_message'];
//
//    return PostStandardResponse(data: data, httpStatusCode: httpStatusCode);
//  }
//
//  Exception _handleError(dynamic e) {
//    print(e);
//    return Exception('Server error; cause: $e');
//  }
//
//}
//
//
//
//
//class Scheduler {
//  String title;
//  String from;
//  String to;
//
//  Scheduler(this.title, this.from, this.to);
//}