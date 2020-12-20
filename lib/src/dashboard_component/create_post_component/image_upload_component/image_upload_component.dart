import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';

@Component(
  selector: 'image-app',
  templateUrl: 'image_upload_component.html',
  styleUrls: ['image_upload_component.css'],
  directives: [coreDirectives],
)

class ImageUploadComponent {
  Future<void> handleUpload(Event event) async {
    event.preventDefault();

    File pic = (event.target as FileUploadInputElement).files[0];

    var reader = FileReader()
      ..readAsArrayBuffer(pic);

    await reader.onLoadEnd.first;
    List<int> result = reader.result;

  }
}