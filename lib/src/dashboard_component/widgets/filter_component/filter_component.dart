import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_components/focus/focus_list.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/laminate/overlay/module.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel_auto_dismiss.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel_set.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_forms/angular_forms.dart';

const List<String> _filters = [
  'All',
  'Posted',
  'Pending',
  'Scheduled',
];
const List<String> _numbers = [
  '10',
  '20',
  '50',
  '100',
];


@Component(
  selector: 'filter',
  templateUrl: 'filter_component.html',
  styleUrls: ['filter_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    FocusListDirective,
    MaterialIconComponent,
    MaterialFabComponent,
    MaterialButtonComponent,
    MaterialExpansionPanel,
    MaterialExpansionPanelAutoDismiss,
    MaterialExpansionPanelSet,
    ModalComponent,
  ],
  providers: [ClassProvider(GetPostService), overlayBindings],
)
class FilterComponent implements OnInit{

  final _filterData = StreamController<FilterData>();
  @Output('sendData')
  Stream<FilterData> get filterData => _filterData.stream;
  @Input('selected')
  int selected = 0;

  List<String> get filters => _filters;
  List<String> get numbers => _numbers;
  String selectedFilter = '';
  String selectedNumber = '';
  List<Post> posts = <Post>[];
  List<Post> filteredPosts = <Post>[];
  List<String> deleteIds = <String>[];
  List<Schedule> schedule = <Schedule>[];
  bool allIsChecked = false;
  bool createNeed = false;
  bool saveCancel = false;
  int postAlertCode = 0;
  bool loading = false;
  bool isRefresh = false;
  bool isDeleting = false;
  bool filterDropdown = false;
  String postAlert = '';
  bool postAlertBool = false;
  String emptyMessage = 'Select filters to apply';
  final GetPostService _getPostService;
  var appTheme;

  FilterComponent(this._getPostService);

  void onSubmit() {
    if((selectedFilter == 'All')) {
      filteredPosts = posts;
      _filterData.add(FilterData(filteredPosts, convInt(selectedNumber)));
    } else if(selectedFilter == 'Posted') {
      filteredPosts = getPostedPosts();
      _filterData.add(FilterData(filteredPosts, convInt(selectedNumber)));
    } else if(selectedFilter == 'Pending') {
      filteredPosts = getPendingPosts();
      _filterData.add(FilterData(filteredPosts, convInt(selectedNumber)));
    } else if(selectedFilter == 'Scheduled') {
      filteredPosts = getScheduledPosts();
      _filterData.add(FilterData(filteredPosts, convInt(selectedNumber)));
    }
  }

  Future<void> remove(String id) async {
    await _getPostService.delete(id);
  }

  void toggleFilterDropdown() {
    filterDropdown = !filterDropdown;
  }


  List<Post> getPostedPosts() {
    List<Post> postedPost = <Post>[];
    for(int counter = 0; counter < posts.length; counter++) {
      if(posts[counter].postStatus) {
        postedPost.add(posts[counter]);
      }
    }
    return postedPost;
  }

  List<Post> getPendingPosts() {
    List<Post> postedPost = <Post>[];
    for(int counter = 0; counter < posts.length; counter++) {
      if(!posts[counter].postStatus) {
        postedPost.add(posts[counter]);
      }
    }
    return postedPost;
  }

  List<Post> getScheduledPosts() {
    List<Post> scheduledPost = <Post>[];
    for(int counter = 0; counter < schedule.length; counter++) {
      for(int i = 0; i < schedule[counter].postIds.length; i++) {
        print('aaa');
        if(searchPosts(schedule[counter].postIds[i])) {
          scheduledPost.add(getPost(schedule[counter].postIds[i]));
        }
      }
    }
    print(scheduledPost.toString());
    return scheduledPost;
  }

  Post getPost(String id) {
    Post postToAdd;
    for(int i = 0; i < posts.length; i++) {
      if(posts[i].id == id) {
        postToAdd = posts[i];
      }
    }
    return postToAdd;
  }

  bool searchPosts(String postId) {
    bool isFound = false;
    for(int i = 0; i < posts.length; i++) {
      if(posts[i].id == postId) {
        isFound = true;
      } else {
        isFound = false;
      }
    }
    return isFound;
  }

  void getAllIds() {
    deleteIds.clear();
    allIsChecked = !allIsChecked;
    if(allIsChecked) {
      for(int i = 0; i < filteredPosts.length; i++) {
        filteredPosts[i].checkedState = true;
        deleteIds.add(filteredPosts[i].id);
      }
    } else {
      for(int i = 0; i < filteredPosts.length; i++) {
        filteredPosts[i].checkedState = false;
        deleteIds.remove(filteredPosts[i].id);
      }
    }

  }

  void getId(int index) {
    filteredPosts[index].checkedState = !filteredPosts[index].checkedState;
    if(filteredPosts[index].checkedState) {
      deleteIds.add(posts[index].id);
    } else {
      deleteIds.remove(posts[index].id);
    }
    print(deleteIds.toString());
  }

  Future<void> batchDelete() async {
    try {
      isDeleting = true;
      PostStandardResponse deleteResponse = await _getPostService.batchDelete(deleteIds);
      isDeleting = false;

      if(deleteResponse.httpStatusCode == 200) {
        for(int i = 0; i < deleteIds.length; i++) {
          window.localStorage.remove(deleteIds[i]);
          posts.remove(stringToPost(deleteIds[i]));
          filteredPosts.remove(stringToPost(deleteIds[i]));
        }
      }
      deleteIds.clear();
      allIsChecked = false;
    } catch(e) {
      isDeleting = false;
    }

  }

  void dismissAlert() {
    postAlertBool = false;
  }

  Post stringToPost(String st) {
    Post deletePost;
    for(int i = 0; i < filteredPosts.length; i++) {
      if(filteredPosts[i].id == st) {
        deletePost = filteredPosts[i];
      }
    }
    return deletePost;
  }

  Future<void> autoSync() async {
    try {
      isRefresh = true;
      posts = await _getPostService.getAllPost();
      isRefresh = false;
      onSubmit();
    } catch(e) {
      isRefresh = false;
    }
  }

  @override
  Future<void> ngOnInit() async {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
    posts = await _getPostService.getAllPost();
    schedule = await _getPostService.getAllScheduledPost();
  }

  int convInt(String selectedNumber) {
    if(selectedNumber == '10') {
      return 10;
    } else if(selectedNumber == '20') {
      return 20;
    } else if(selectedNumber == '50') {
      return 50;
    } else if(selectedNumber == '100') {
      return 100;
    } else {
      return 10;
    }
  }
}

class FilterData {
  List<Post> finalPost;
  int selectedPostPerPage;
  FilterData(this.finalPost, this.selectedPostPerPage);
}