import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart'
    show GetPostService, Post, Schedule;
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_app/src/dashboard_component/widgets/emojis_component/emojis_component.dart';
import 'package:angular_app/src/dashboard_component/widgets/filter_component/filter_component.dart';
import 'package:angular_app/variables.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'view-post',
  templateUrl: 'view_post_component.html',
  styleUrls: ['view_post_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    MaterialCheckboxComponent,
    MaterialIconComponent,
    MaterialChipComponent,
    MaterialChipsComponent,
    routerDirectives,
    FilterComponent,
    AlertComponent,
    EmojisComponent,
    routerDirectives,
  ],
  exports: [InnerRoutes, InnerRoutePaths],
  providers: [ClassProvider(GetPostService)],
  pipes: [commonPipes],
)
class ViewPostComponent implements OnInit {
  var appTheme;
  Router _router;
  bool allIsChecked = false;
  bool loading = false;
  bool isDeleting = false;
  bool editPopup = false;
  bool displayEmojiContainer = false;
  List<String> imgBytes = <String>[];
  List<String> selectedIds = <String>[];
  List<Post> filteredPosts = <Post>[];
  List<bool> tabs = <bool>[true, false, false];
  Alert setAlert;
  StreamSubscription<MouseEvent> listener;
  int selectedPostIndex;

  int itemsPerPage = 10;
  int currentPage = 1;
  int maxPage;
  int i;

  String message = '';
  String hashtag = '';
  List<String> hashTags = <String>[];
  int insertPosition = 0;

  List<String> fileNames = <String>[];
  String fileName = '';

  String imgPath = '';
  int counter = -1;
  List<String> imgPaths = <String>[];
  List<int> imagesProgress = <int>[0, 0, 0, 0, 0, 0];

  bool failed = false;

  GetPostService _getPostService;

  ViewPostComponent(this._getPostService, this._router);

  Future<void> gotoPosts() async {
    _router.navigate(InnerRoutePaths.create_post.toUrl());
  }

  Future<void> gotoSchedules() async {
    _router.navigate(InnerRoutePaths.manage_post.toUrl());
  }

  void getAllFilterData(FilterData data) {
    filteredPosts = data.finalPost;
    itemsPerPage = data.selectedPostPerPage;
    loading = data.loadingState;
    setAlert = data.alert;
    Timer(Duration(seconds: 5), resetAlert);
  }

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
  }

  Future<void> deleteFile(int index) async {
    List<String> updatedImageList = <String>[];
    // ignore: sdk_version_ui_as_code
    updatedImageList = [...imgPaths];
    updatedImageList.removeAt(index);

    try {
      PostStandardResponse resp = await _getPostService.update(
          filteredPosts[selectedPostIndex].id,
          filteredPosts[selectedPostIndex].postMessage,
          filteredPosts[selectedPostIndex].postTag,
          image: updatedImageList);

      if (resp.httpStatusCode == 200) {
        imgPaths.removeAt(index);
        setAlert = Alert('Deleted image successfully', 200);
        Timer(Duration(seconds: 3), resetAlert);
      }
    } catch (e) {
      setAlert = Alert('Failed to delete image', 500);
      Timer(Duration(seconds: 3), resetAlert);
    }
  }

  DateTime presentDate(String date) {
    Pattern x = 'T';
    return DateTime.parse(date.split(x)[0]);
  }

  String presentTime(String date) {
    Pattern x = 'T';
    Pattern y = ':';
    return date.split(x)[1].split(y)[0] + ':' + date.split(x)[1].split(y)[1];
  }

  void addTag() {
    hashTags.add(hashtag);
    hashtag = '';
  }

  void removeTag(int index) {
    hashTags.removeAt(index);
  }

  void toggleEmojiContainer() {
    displayEmojiContainer = !displayEmojiContainer;
  }

  void togglePopup(int index) {
    editPopup = !editPopup;
    var dashHome = getDocument().getElementById('view-app');
    if (editPopup) {
      index = ((currentPage - 1) * itemsPerPage) + index;
      selectedPostIndex = index;

      counter = -1;
      imgPaths.clear();
      imagesProgress = [0, 0, 0, 0, 0, 0];

      message = filteredPosts[index].postMessage;
      // ignore: sdk_version_ui_as_code
      hashTags = [...filteredPosts[index].postTag];
      // ignore: sdk_version_ui_as_code
      imgBytes = [...filteredPosts[index].postImage];
      // ignore: sdk_version_ui_as_code
      fileNames = [...filteredPosts[index].imagePaths];

      if (imgBytes.isNotEmpty) {
        imgPaths.clear();
        for (int i = 0; i < imgBytes.length; i++) {
          counter = (imgBytes.length) - 1;
          imgPaths.add('data:image/jpeg;base64,' + imgBytes[i]);
          imagesProgress.insert(i, 100);
        }
      }

      dashHome.style.filter = 'blur(3px) brightness(0.9)';
      Timer(Duration(milliseconds: 100), afterClose);
    } else {
      displayEmojiContainer = false;
      dashHome.style.filter = 'blur(0) brightness(1)';
      tabs = [true, false, false];
    }
  }

  void afterClose() {
    var dashHome = getDocument().getElementById('view-app');
    listener = dashHome.onClick.listen((event) {
      closePopup();
    });
  }

  void closePopup() {
    var dashHome = getDocument().getElementById('view-app');
    editPopup = false;
    displayEmojiContainer = false;
    dashHome.style.filter = 'blur(0) brightness(1)';
    tabs = [true, false, false];
    imgPaths.clear();
    imagesProgress.clear();
    listener.cancel();
  }

  void switchTabs(int index) {
    for (int i = 0; i < tabs.length; i++) {
      if (index == i) {
        tabs[i] = true;
      } else {
        tabs[i] = false;
      }
    }
  }

  void getAllIds() {
    selectedIds.clear();
    !allIsChecked;
    if (allIsChecked) {
      for (int i = 0; i < filteredPosts.length; i++) {
        filteredPosts[i].checkedState = true;
        selectedIds.add(filteredPosts[i].id);
      }
    } else {
      for (int i = 0; i < filteredPosts.length; i++) {
        filteredPosts[i].checkedState = false;
        selectedIds.remove(filteredPosts[i].id);
      }
    }
  }

  void getId(int index) {
    index = ((currentPage - 1) * itemsPerPage) + index;
    !filteredPosts[index].checkedState;
    if (filteredPosts[index].checkedState) {
      selectedIds.add(filteredPosts[index].id);
    } else {
      selectedIds.remove(filteredPosts[index].id);
    }
  }

  void setData(data) {
    arrangePostMessage(data);
  }

  void getInputSelection(TextAreaElement el) {
    var endPosition = el.selectionEnd;
    insertPosition = endPosition;
  }

  void arrangePostMessage(String emoValue) {
    List<String> postMessageList = <String>[];

    if (message.isNotEmpty) {
      for (int i = 0; i < message.length; i++) {
        postMessageList.add(message[i]);
      }
      postMessageList.insert(insertPosition, emoValue);
      insertPosition += 2;
    } else {
      /*postMessage = postMessage + emoValue;*/
      postMessageList.add(emoValue);
      insertPosition += 2;
    }

    message = '';

    for (int i = 0; i < postMessageList.length; i++) {
      message = message + postMessageList[i];
    }
  }

  void resetAlert() {
    setAlert = null;
  }

  Future<void> updatePost() async {
    message = message.trim();
    if (message.isEmpty) return null;

    try {
      PostStandardResponse resp = await _getPostService.update(
          filteredPosts[selectedPostIndex].id, message, hashTags,
          image: imgPaths);
      setAlert = Alert(resp.data.message, resp.httpStatusCode);
      Timer(Duration(seconds: 5), resetAlert);

      if (resp.httpStatusCode == 200) {
        filteredPosts[selectedPostIndex].postMessage = message;
        filteredPosts[selectedPostIndex].postImage = imgPaths;
        filteredPosts[selectedPostIndex].scheduleStatus = false;
        filteredPosts[selectedPostIndex].fbStatus = false;
        filteredPosts[selectedPostIndex].twStatus = false;
        filteredPosts[selectedPostIndex].liStatus = false;
        filteredPosts[selectedPostIndex].postTag = hashTags;
        message = '';
        hashTags.clear();
        closePopup();
      }
    } catch (e) {
      setAlert = Alert('Failed to update post', 500);
      Timer(Duration(seconds: 5), resetAlert);
    }
  }

  @override
  Future<void> ngOnInit() async {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
  }

  Future<void> batchDelete() async {
    String isPlural = plural(selectedIds);
    try {
      isDeleting = true;
      PostStandardResponse deleteResponse =
          await _getPostService.batchDelete(selectedIds);
      isDeleting = false;
      if (deleteResponse.httpStatusCode == 200) {
        for (int i = 0; i < selectedIds.length; i++) {
          window.sessionStorage.remove(selectedIds[i]);
          filteredPosts.remove(convertStringToPost(selectedIds[i]));
        }
      }
      selectedIds.clear();
      allIsChecked = false;
      setAlert = Alert('Deleted selected post$isPlural successfully', 200);
      Timer(Duration(seconds: 5), resetAlert);
    } catch (e) {
      isDeleting = false;
      setAlert = Alert('Failed to delete selected post$isPlural', 500);
      Timer(Duration(seconds: 5), resetAlert);
    }
  }

  String plural(List<dynamic> list) {
    return list.length > 1 ? 's' : '';
  }

  Post convertStringToPost(String st) {
    Post deletePost;
    for (int i = 0; i < filteredPosts.length; i++) {
      if (filteredPosts[i].id == st) {
        deletePost = filteredPosts[i];
      }
    }
    return deletePost;
  }

  int conv(idx) {
    if (idx is String) {
      this.i = int.parse(idx);
    } else if (idx == null) {
      this.i = 1;
    } else {
      this.i = idx;
    }
    return this.i;
  }

  List range() {
    this.maxPage = (filteredPosts.length / conv(itemsPerPage)).ceil();
    List ret = [];
    for (var i = 1; i <= this.maxPage; i++) {
      ret.add(i);
    }
    return ret;
  }

  void setPage(n) {
    this.currentPage = n;
  }

  void prevPage() {
    if (this.currentPage > 1) {
      --this.currentPage;
    }
  }

  void nextPage() {
    if (this.currentPage < this.maxPage) {
      ++this.currentPage;
    }
  }

  String prevPageDisabled() {
    return this.currentPage == 1 ? "disabled" : "";
  }

  String nextPageDisabled() {
    return this.currentPage == this.maxPage ? "disabled" : "";
  }
}
