import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart'
    show GetPostService, Post, Schedule;
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_app/src/dashboard_component/widgets/emojis_component/emojis_component.dart';
import 'package:angular_app/src/dashboard_component/widgets/filter_component/filter_component.dart';
import 'package:angular_app/src/dashboard_component/widgets/image_upload_component/image_upload_component.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
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
    ImageUploadComponent,
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
  List<String> selectedIds = <String>[];
  List<Post> filteredPosts = <Post>[];
  List<bool> tabs = <bool>[true, false, false];
  Alert setAlert;
  StreamSubscription<MouseEvent> listener;
  int selectedPostIndex;
  int focusScheduleId = null;
  int itemsPerPage = 10;
  int currentPage = 1;
  int maxPage;
  int i;

  String message = '';
  String hashtag = '';
  List<String> postTags = <String>[];
  int insertPosition = 0;

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

  void addTag() {
    postTags.add(hashtag);
    hashtag = '';
  }

  void removeTag(int index) => postTags.removeAt(index);

  void toggleEmojiContainer() {
    displayEmojiContainer = !displayEmojiContainer;
  }

  void togglePopup(int index) {
    editPopup = !editPopup;
    var dashHome = getDocument().getElementById('view-app');
    if (editPopup) {
      focusScheduleId = index;
      index = ((currentPage - 1) * itemsPerPage) + index;
      selectedPostIndex = index;
      message = filteredPosts.elementAt(index).postMessage;
      postTags = filteredPosts.elementAt(index).postTag;
      dashHome.style.filter = 'blur(3px) brightness(0.9)';
      Timer(Duration(milliseconds: 100), afterClose);
    } else {
      focusScheduleId = null;
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
      PostStandardResponse resp = await _getPostService
          .update(filteredPosts[selectedPostIndex].id, message, postTags, []);
      setAlert = Alert(resp.data.message, resp.httpStatusCode);
      Timer(Duration(seconds: 5), resetAlert);

      if (resp.httpStatusCode == 200) {
        Post newPost =
            Post(message, postTag: postTags, id: resp.data.id, postImage: []);

        filteredPosts.removeAt(selectedPostIndex);
        filteredPosts.insert(selectedPostIndex, newPost);

        message = '';
        postTags.clear();
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
    } catch (e) {
      isDeleting = false;
      setAlert = Alert(
          'Failed to delete selected post${selectedIds.length > 1 ? 's' : ''}',
          500);
      Timer(Duration(seconds: 5), resetAlert);
    }
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
