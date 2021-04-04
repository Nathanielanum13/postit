import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_app/variables.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:http/http.dart';
@Component(
  selector: 'image-app',
  templateUrl: 'image_upload_component.html',
  styleUrls: ['image_upload_component.css'],
  directives: [coreDirectives],
)

class ImageUploadComponent {

  List<String> fileNames = <String>[];
  String fileName = '';

  String imgPath = '';
  int counter = -1;
  List<String> imgPaths = <String>[];
  List<int> imagesProgress = <int>[0, 0, 0, 0, 0, 0];

  bool failed = false;
  Alert setAlert;

  Future<void> handleUpload(form, Event event) async {
    event.preventDefault();
    var formData = FormData(form);
    final request = HttpRequest();

    for(int i = 0; i < (event.target as FileUploadInputElement).files.length; i++) {
      counter += 1;
      if(i < 6 && counter < 6) {
        File pic = (event.target as FileUploadInputElement).files[i];
        fileNames.add(pic.name);

        var reader = FileReader()
          ..readAsDataUrl(pic);

        await reader.onLoadEnd.first;
        imgPaths.add(reader.result);

        request.open("POST", "${env['MEDIA_UPLOAD_URL']}");
        request.setRequestHeader('trace-id', '8923002323732uhi2o388y7372838932');
        request.setRequestHeader('tenant-namespace', '${window.sessionStorage['tenant-namespace']}');
        request.setRequestHeader('Authorization', 'Bearer ${window.sessionStorage['token']}');
        request.upload.onProgress.listen((ProgressEvent progress){
          imagesProgress.insert(counter, progress.loaded*100~/progress.total);
        });

        request.onLoad.listen((e) {
          print('Uploaded');
        });

        request.onError.listen((event) {
          failed = true;
        });

        request.send(formData);
      } else {
        setAlert = Alert('You can not add more than 6 images', 400);
        Timer(Duration(seconds: 5), resetAlert);
        return;
      }
    }
  }

  void resetAlert() {
    setAlert = null;
  }

  Future<void> deleteFile(int index) async {
    Response resp;
    try {
      resp = await delete('${env['MEDIA_UPLOAD_URL']}' + '?file_name=${fileNames[index]}', headers: {
        'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
        'tenant-namespace': '${window.sessionStorage['tenant-namespace']}',
        'Authorization': 'Bearer ${window.sessionStorage['token']}'
      });
    } catch(e) {
      print('');
    }
    /*print(json.decode(resp.body)['ui_message']);*/
  }
}