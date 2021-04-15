import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_app/src/dashboard_component/widgets/csv_upload_component/csv_upload_component.dart';
import 'package:angular_app/src/dashboard_component/widgets/emojis_component/emojis_component.dart';
import 'package:angular_app/variables.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:http/http.dart';

@Component(
  selector: 'create-post',
  templateUrl: 'create_post_component.html',
  styleUrls: ['create_post_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialCheckboxComponent,
    FixedMaterialTabStripComponent,
    MaterialToggleComponent,
    MaterialChipComponent,
    MaterialChipsComponent,
    MaterialToggleComponent,
    CsvUploadComponent,
    EmojisComponent,
    AlertComponent,
  ],
  providers: [ClassProvider(GetPostService)],
)
class CreatePostComponent implements OnInit, CanNavigate {
  final GetPostService _getPostService;

  Alert setAlert;
  String postAlert = '';
  bool postAlertBool = false;
  bool editKey = false;
  bool toggleState = false;
  bool exitPopup = false;
  bool allIsChecked = false;
  bool loading = false;
  bool isSending = false;
  bool failed = false;
  bool isDel = false;
  bool finalBool = false;
  int postAlertCode = 0;

  String postMessage = '';
  String hashtag = '';
  String imageFile, fileFile = 'Select file to upload...';
  List<String> postImage;
  List<String> postTags = <String>[];
  List<String> deleteIds = <String>[];
  List<Post> currentPosts = <Post>[];
  List<String> fileNames = <String>[];
  String fileName = '';
  String _updatePostId = '';
  String funcCall = '';
  int _updatePostIndex;
  int insertPosition = 0;
  String imgPath = '';
  int counter = -1;
  List<String> imgPaths = <String>[];
  List<int> imagesProgress = <int>[0, 0, 0, 0, 0, 0];
  List<bool> editKeys = <bool>[];
  var appTheme;

  StreamSubscription<MouseEvent> listener;

  CreatePostComponent(this._getPostService);

  Future<void> handleUpload(form, Event event) async {
    event.preventDefault();
    var formData = FormData(form);
    final request = HttpRequest();

    counter += 1;
    if (counter < 6) {
      File pic = (event.target as FileUploadInputElement).files[0];
      fileNames.add(pic.name);

      var reader = FileReader()..readAsDataUrl(pic);

      await reader.onLoadEnd.first;
      imgPaths.add(reader.result);

      request.open("POST", "${env['MEDIA_UPLOAD_URL']}");
      request.setRequestHeader('trace-id', '8923002323732uhi2o388y7372838932');
      request.setRequestHeader(
          'tenant-namespace', '${window.sessionStorage['tenant-namespace']}');
      request.setRequestHeader(
          'Authorization', 'Bearer ${window.sessionStorage['token']}');

      request.upload.onProgress.listen((ProgressEvent progress) {
        imagesProgress.insert(counter, progress.loaded * 100 ~/ progress.total);
      });

      request.onLoad.listen((e) {
        print('${counter} :: Uploaded');
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

    /*for (int i = 0;
        i < (event.target as FileUploadInputElement).files.length;
        i++) {
      counter += 1;
      if (i < 6 && counter < 6) {

      } else {
        setAlert = Alert('You can not add more than 6 images', 400);
        Timer(Duration(seconds: 5), resetAlert);
        return;
      }
    }*/
  }

  Future<void> deleteFile(int index) async {
    try {
      final resp = await delete(
          '${env['MEDIA_UPLOAD_URL']}' + '?file_name=${fileNames[index]}',
          headers: {
            'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
            'tenant-namespace': '${window.sessionStorage['tenant-namespace']}',
            'Authorization': 'Bearer ${window.sessionStorage['token']}'
          });
      if (resp.statusCode == 200) {
        imgPaths.removeAt(index);
        fileNames.removeAt(index);
        counter = counter - 1;
        setAlert = Alert(
            json.decode(resp.body)['data']['ui_message'], resp.statusCode);
        Timer(Duration(seconds: 5), resetAlert);
      }
    } catch (e) {
      setAlert = Alert('Delete operation failed', 400);
      Timer(Duration(seconds: 5), resetAlert);
    }
    /*print(json.decode(resp.body)['ui_message']);*/
  }

  void getAllIds() {
    deleteIds.clear();
    if (allIsChecked) {
      for (int i = 0; i < currentPosts.length; i++) {
        currentPosts[i].checkedState = true;
        deleteIds.add(currentPosts[i].id);
      }
    } else {
      for (int i = 0; i < currentPosts.length; i++) {
        currentPosts[i].checkedState = false;
        deleteIds.remove(currentPosts[i].id);
      }
    }
  }

  void getId(int index) {
    if (currentPosts[index].checkedState) {
      deleteIds.add(currentPosts[index].id);
    } else {
      deleteIds.remove(currentPosts[index].id);
    }
  }

  Future<void> batchDelete() async {
    try {
      loading = true;
      checkLoadingState(loading);
      PostStandardResponse deleteResponse =
          await _getPostService.batchDelete(deleteIds);
      loading = false;
      checkLoadingState(loading);
      setAlert =
          Alert(deleteResponse.data.message, deleteResponse.httpStatusCode);
      Timer(Duration(seconds: 5), resetAlert);

      if (deleteResponse.httpStatusCode == 200) {
        for (int i = 0; i < deleteIds.length; i++) {
          window.sessionStorage.remove(deleteIds[i]);
          currentPosts.remove(stringToPost(deleteIds[i]));
        }
      }
      deleteIds.clear();
      allIsChecked = false;
    } catch (e) {
      loading = false;
      checkLoadingState(loading);
      setAlert = Alert('Failed to delete selected posts', 500);
      Timer(Duration(seconds: 5), resetAlert);
    }
  }

  Post stringToPost(String st) {
    Post deletePost;
    for (int i = 0; i < currentPosts.length; i++) {
      if (currentPosts[i].id == st) {
        deletePost = currentPosts[i];
      }
    }
    return deletePost;
  }

  void getInputSelection(TextAreaElement el) {
    var endPosition = el.selectionEnd;
    insertPosition = endPosition;
  }

  void resetAlert() {
    setAlert = null;
  }

  void setData(data) {
    arrangePostMessage(data);
  }

  void arrangePostMessage(String emoValue) {
    List<String> postMessageList = <String>[];

    if (postMessage.isNotEmpty) {
      for (int i = 0; i < postMessage.length; i++) {
        postMessageList.add(postMessage[i]);
      }
      postMessageList.insert(insertPosition, emoValue);
      insertPosition += 2;
    } else {
      /*postMessage = postMessage + emoValue;*/
      postMessageList.add(emoValue);
      insertPosition += 2;
    }

    postMessage = '';

    for (int i = 0; i < postMessageList.length; i++) {
      postMessage = postMessage + postMessageList[i];
    }
  }


  Future<void> addPost() async {
    postMessage = postMessage.trim();
    if (postMessage.isEmpty) return null;

    try {
      isSending = true;
      checkLoadingState(true);
      PostStandardResponse resp = await _getPostService.create(postMessage,
          tags: postTags, priority: toggleState);
      checkLoadingState(false);
      isSending = false;

      setAlert = Alert(resp.data.message, resp.httpStatusCode);
      Timer(Duration(seconds: 5), resetAlert);

      if (resp.httpStatusCode == 200) {
        Post newPost = Post(postMessage,
            postTag: postTags,
            id: resp.data.id,
            postImage: postImage,
            postPriority: toggleState);

        currentPosts.add(newPost);
        savePost(newPost);
        editKeys.add(newPost.edit);

        postMessage = '';
        postTags.clear();
        imgPaths.clear();
        fileNames.clear();
        toggleState = false;

        counter = -1;
      }
    } catch (e) {
      checkLoadingState(false);
      isSending = false;

      setAlert = Alert('Failed to create post', 500);
      Timer(Duration(seconds: 5), resetAlert);
    }
  }

  Future<void> updatePost() async {
    postMessage = postMessage.trim();
    if (postMessage.isEmpty) return null;

    try {
      isSending = true;
      checkLoadingState(true);
      PostStandardResponse resp = await _getPostService.update(
          _updatePostId, postMessage, postTags);
      checkLoadingState(false);
      isSending = false;

      setAlert = Alert(resp.data.message, resp.httpStatusCode);
      Timer(Duration(seconds: 5), resetAlert);

      if (resp.httpStatusCode == 200) {
        Post newPost = Post(postMessage,
            postTag: postTags, id: resp.data.id, postImage: postImage);

        currentPosts.removeAt(_updatePostIndex);
        currentPosts.insert(_updatePostIndex, newPost);

        savePost(newPost);

        postMessage = '';
        postTags.clear();

        counter = -1;
      }

      editKey = false;

      for (int i = 0; i < editKeys.length; i++) {
        editKeys[i] = false;
      }
    } catch (e) {
      isSending = false;
      checkLoadingState(false);
      setAlert = Alert('Failed to update post', 500);
      Timer(Duration(seconds: 5), resetAlert);
    }
  }

  Future<void> remove(int index) async {
    String id = currentPosts[index].id;
    try {
      loading = true;
      checkLoadingState(loading);
      PostStandardResponse deleteResponse = await _getPostService.delete(id);
      loading = false;
      checkLoadingState(loading);
      setAlert =
          Alert(deleteResponse.data.message, deleteResponse.httpStatusCode);
      Timer(Duration(seconds: 5), resetAlert);

      if (deleteResponse.httpStatusCode == 200) {
        window.sessionStorage.remove(id);
        currentPosts.removeAt(index);
      }
    } catch (e) {
      loading = false;
      checkLoadingState(loading);
      setAlert = Alert('Failed to delete post', 500);
      Timer(Duration(seconds: 5), resetAlert);
    }
  }

  void removeTag(int index) => postTags.removeAt(index);

  void addTag() {
    postTags.add(hashtag);
    hashtag = '';
  }

  void savePost(Post new_post) {
    Storage sessionStorage = window.sessionStorage;
    var keyId = new_post.id;

    var post = {
      'id': new_post.id,
      'post_message': new_post.postMessage,
      'hash_tags': new_post.postTag,
      'post_image': new_post.postPic,
      'post_priority': new_post.postPriority,
    };
    sessionStorage['$keyId'] = json.encode(post);
  }

  List<Post> fetchPost() {
    Storage ls = window.sessionStorage;
    List<Post> posts = <Post>[];
    var d;

    for (int i = 0; i < ls.values.length; i++) {
      if (ls.keys.elementAt(i) == 'token' ||
          ls.keys.elementAt(i) == 'tenant-namespace' ||
          ls.keys.elementAt(i) == 'x-data') {
        continue;
      } else {
        d = json.decode(ls.values.elementAt(i));
      }
      Post newPost = Post(d['post_message'],
          id: d['id'],
          postTag: convertLDS(d['hash_tags']),
          postPic: d['post_image']);
      posts.add(newPost);
      editKeys.add(newPost.edit);
    }
    return posts;
  }

  void editPost(int index) {
    editKeys[index] = !editKeys[index];

    if (editKeys[index]) {
      editKey = true;
      for (int i = 0; i < editKeys.length; i++) {
        if (i == index) {
          continue;
        } else {
          editKeys[i] = false;
        }
      }
    } else {
      editKey = false;
    }

    var post_id = currentPosts[index].id;
    Storage editLocal = window.sessionStorage;
    var decodedJson = json.decode(editLocal['$post_id']);

    postMessage = decodedJson['post_message'];
    postTags = convertLDS(decodedJson['hash_tags']);
    postImage = decodedJson['post_image'];
    toggleState = decodedJson['post_priority'];

    _updatePostId = post_id;
    _updatePostIndex = index;
  }

  @override
  void ngOnInit() {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
    currentPosts = fetchPost();
  }

  void checkLoadingState(bool loading) {
    var doc = getDocument();
    if (loading) {
      doc.querySelectorAll('.create-table-info').style.filter = 'blur(5px)';
    } else {
      doc.querySelectorAll('.create-table-info').style.filter = 'blur(0)';
    }
  }

  void togglePopup() {
    exitPopup = !exitPopup;
    var dashHome = getDocument().getElementById('create-app');
    if (exitPopup) {
      dashHome.style.filter = 'blur(3px)';
      Timer(Duration(milliseconds: 100), afterClose);
    } else {
      dashHome.style.filter = 'blur(0)';
    }
  }

  void afterClose() {
    var dashHome = getDocument().getElementById('create-app');
    listener = dashHome.onClick.listen((event) {
      closePopup();
    });
  }

  void closePopup() {
    var dashHome = getDocument().getElementById('create-app');
    exitPopup = false;
    dashHome.style.filter = 'blur(0)';
    listener.cancel();
  }

  Future<bool> deleteFinalImages() async {
    finalBool = true;
    isDel = true;
    if (fileNames.isNotEmpty) {
      try {
        final resp = await delete(
            '${env['MEDIA_BATCH_UPLOAD_URL']}',
            headers: {
              'trace-id': '1ab53b1b-f24c-40a1-93b7-3a03cddc05e6',
              'tenant-namespace': '${window.sessionStorage['tenant-namespace']}',
              'Authorization': 'Bearer ${window.sessionStorage['token']}'
            });
        if (resp.statusCode == 200) {
          finalBool = true;
        }
      } catch (e) {
        isDel = false;
        finalBool = false;
      }
    }

    return finalBool;
  }

  @override
  Future<bool> canNavigate() async {
    if (fileNames.isEmpty) return true;
    bool isPermitted = window.confirm('Are you sure you want to exit? You would loose currently uploaded images');
    if (isPermitted) {
      return deleteFinalImages();
    }
    return false;
  }
}
