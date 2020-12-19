import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_router/angular_router.dart';


const List<String> _filters = [
  'All',
  'Posted',
  'Scheduled',
  'Unscheduled',
];
const List<String> _numbers = [
  '20',
  '50',
  '100',
  '100+',
];

@Component(
  selector: 'view-post',
  templateUrl: 'view_post_component.html',
  styleUrls: ['view_post_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    MaterialCheckboxComponent,
    routerDirectives
  ],
  providers: [ClassProvider(GetPostService)],
  exports: [InnerRoutes, InnerRoutePaths]
)
class ViewPostComponent implements OnInit {
  final GetPostService _getPostService;

  List<String> get filters => _filters;
  List<String> get numbers => _numbers;
  List<Post> posts = <Post>[];
  List<Post> filteredPosts = <Post>[];
  List<String> deleteIds = <String>[];
  List<Schedule> schedule = <Schedule>[];

  String selectedFilter = '';
  String selectedNumber = '';

  bool allIsChecked = false;
  bool createNeed = false;
  int postAlertCode = 0;
  bool loading = false;
  bool isRefresh = false;
  String postAlert = '';
  bool postAlertBool = false;
  String emptyMessage = 'Select filters to apply';


  ViewPostComponent(this._getPostService);


  Future<void> remove(String id) async {
    await _getPostService.delete(id);
  }

  void onSubmit() {
    if((selectedFilter == 'All' && selectedNumber.isEmpty) || (selectedFilter == 'All' && selectedNumber == '100+')) {
      checkPostStatus();
      filteredPosts = posts;
    } else if(selectedFilter == 'All' && selectedNumber == '20') {
      checkPostStatus();
      if(posts.length < 20) {
        filteredPosts = posts;
      } else {
        filteredPosts = posts.getRange(0, 20).toList();
      }
    } else if(selectedFilter == 'All' && selectedNumber == '50') {
      checkPostStatus();
      if(posts.length < 50) {
        filteredPosts = posts;
      } else {
        filteredPosts = posts.getRange(0, 50).toList();
      }
    } else if(selectedFilter == 'All' && selectedNumber == '100') {
      checkPostStatus();
      if(posts.length < 100) {
        filteredPosts = posts;
      } else {
        filteredPosts = posts.getRange(0, 100).toList();
      }
    } else if((selectedFilter == 'Posted' && selectedNumber.isEmpty) || (selectedFilter == 'Posted' && selectedNumber == '100+')) {
      checkPostStatus();
      filteredPosts = getPostedPosts();
    } else if(selectedFilter == 'Posted' && selectedNumber == '20') {
      checkPostStatus();
      if(getPostedPosts().length < 20) {
        filteredPosts = getPostedPosts();
      } else {
        filteredPosts = getPostedPosts().getRange(0, 20).toList();
      }
    } else if(selectedFilter == 'Posted' && selectedNumber == '50') {
      checkPostStatus();
      if(getPostedPosts().length < 50) {
        filteredPosts = getPostedPosts();
      } else {
        filteredPosts = getPostedPosts().getRange(0, 50).toList();
      }
    }else if(selectedFilter == 'Posted' && selectedNumber == '100') {
      checkPostStatus();
      if(getPostedPosts().length < 100) {
        filteredPosts = getPostedPosts();
      } else {
        filteredPosts = getPostedPosts().getRange(0, 100).toList();
      }
    } else if((selectedFilter == 'Scheduled' && selectedNumber.isEmpty) || (selectedFilter == 'Posted' && selectedNumber == '100+')) {
      checkPostStatus();
      filteredPosts = getScheduledPosts();
      print(filteredPosts.toList().toString());
    } else if(selectedFilter == 'Scheduled' && selectedNumber == '20') {
      checkPostStatus();
      if(getScheduledPosts().length < 20) {
        filteredPosts = getScheduledPosts();
      } else {
        filteredPosts = getScheduledPosts().getRange(0, 20).toList();
      }
    } else if(selectedFilter == 'Scheduled' && selectedNumber == '50') {
      checkPostStatus();
      if(getScheduledPosts().length < 50) {
        filteredPosts = getScheduledPosts();
      } else {
        filteredPosts = getScheduledPosts().getRange(0, 50).toList();
      }
    }else if(selectedFilter == 'Scheduled' && selectedNumber == '100') {
      checkPostStatus();
      if(getScheduledPosts().length < 100) {
        filteredPosts = getScheduledPosts();
      } else {
        filteredPosts = getScheduledPosts().getRange(0, 100).toList();
      }
    }
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

  Future<void> checkPostStatus() async {
    if(posts.isEmpty) {
      loading = true;
      try {
        posts = await _getPostService.getAllPost().timeout(Duration(seconds: 5));
        loading = false;
        emptyMessage = 'No post';
        createNeed = true;
      } catch(e) {
        postAlert = 'Server offline. Request timeout';
        postAlertCode = 500;
        postAlertBool = true;
        loading = false;
        Timer(Duration(seconds: 5), dismissAlert);

      }
    } else {
      loading = false;
      createNeed = false;
    }
  }

  void getAllIds() {
    deleteIds.clear();
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
    if(filteredPosts[index].checkedState) {
      deleteIds.add(posts[index].id);
    } else {
      deleteIds.remove(posts[index].id);
    }
    print(deleteIds.toString());;
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

  Future<void> batchDelete() async {
    try {
      PostStandardResponse deleteResponse = await _getPostService.batchDelete(deleteIds);

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
      print(e);
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

  @override
  Future<void> ngOnInit() async {
    // TODO: implement ngOnInit
    posts = await _getPostService.getAllPost();
    schedule = await _getPostService.getAllScheduledPost();
  }
}