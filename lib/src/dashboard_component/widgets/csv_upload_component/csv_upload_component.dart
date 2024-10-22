import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'csv-app',
  templateUrl: 'csv_upload_component.html',
  styleUrls: ['csv_upload_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    MaterialProgressComponent
  ]
)
class CsvUploadComponent {
  GetPostService _getPostService;

  String postAlert = '';
  bool postAlertBool = false;
  bool progressStatus = false;
  int postAlertCode = 0;
  int activeProgress = 0;

  String csvFileName = 'Select CSV file';
  List<String> column_one = <String>[], column_two = <String>[], column_three = <String>[];

  CsvUploadComponent(this._getPostService);


  Future<void> handleFileUpload(Event event) async {
    event.preventDefault();
    File file = (event.target as FileUploadInputElement).files[0];
    csvFileName = file.name;

    var reader = FileReader()
      ..readAsText(file);

    await reader.onLoadEnd.first;
    String result = reader.result;

    Pattern pattern = ',';
    List<String> csvFile = result.split(pattern);
    csvFile.removeLast();
    print(csvFile);


    int j = 0;
    for(int i = 0; i < csvFile.length; i++) {
      j += 2;
      if(j < csvFile.length) {
        column_one.add(csvFile[j]);
        column_two.add(csvFile[j+1]);
      } else {
        break;
      }
    }
  }

  Future<void> doUpload() async {
    try {
      activeProgress = 0;
      progressStatus = true;
      if(column_one.length == column_two.length) {
        for(int i = 0; i < column_one.length; i++) {
          /*await _getPostService.create(column_one[i], tags: trimColumn(column_two[i]), priority:false);*/
          print('${trimColumn(column_one[i])}');
          /*||| (${trimColumn(column_two[i])}) ||| ${trimColumn(column_three[i])}*/
          getActiveProgress(i);
        }
        csvFileName = 'Select CSV file';
        progressStatus = false;

      }
    } catch(e) {

    }
  }

  String trimColumn(String str) {
    /*List<String> result = <String>[];*/

    str.trimRight();
    str.trimLeft();

    /*Pattern pattern = ',';
    result = str.split(pattern);

    if(result.last == '') {
      result.removeLast();
    }*/

    return str;
  }

  void getActiveProgress(int i) {
    activeProgress = ((i / (column_one.length - 1)) * 100).toInt();
  }


}