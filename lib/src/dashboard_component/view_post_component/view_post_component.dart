import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';


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
  ],
  providers: [ClassProvider(GetPostService)],
)
class ViewPostComponent implements OnInit {

  final GetPostService _getPostService;
  List<String> get filters => _filters;
  List<String> get numbers => _numbers;
  List<Post> posts = <Post>[];
  List<Post> filteredPosts = <Post>[];
  List<String> deleteIds = <String>[];

  String selectedFilter = '';
  String selectedNumber = '';

  bool allIsChecked = false;
  int postAlertCode = 0;
  bool loading = false;
  String postAlert = '';
  bool postAlertBool = false;
  String emptyMessage = 'Select filters to apply';


  ViewPostComponent(this._getPostService);

  Future<void> remove(String id) async {
    await _getPostService.delete(id);
  }

  void onSubmit() {
    if((selectedFilter == 'All' && selectedNumber.isEmpty) || (selectedFilter == 'All' && selectedNumber == '100+')) {
      print('Statement 1');
      checkPostStatus();
      filteredPosts = posts;
    } else if(selectedFilter == 'All' && selectedNumber == '20') {
      print('Statement 2');
      checkPostStatus();
      if(posts.length < 20) {
        filteredPosts = posts;
      } else {
        filteredPosts = posts.getRange(0, 20).toList();
      }
    } else if(selectedFilter == 'All' && selectedNumber == '50') {
      print('Statement 3');
      checkPostStatus();
      if(posts.length < 50) {
        filteredPosts = posts;
      } else {
        filteredPosts = posts.getRange(0, 50).toList();
      }
    } else if(selectedFilter == 'All' && selectedNumber == '100') {
      print('Statement 4');
      checkPostStatus();
      if(posts.length < 100) {
        filteredPosts = posts;
      } else {
        filteredPosts = posts.getRange(0, 100).toList();
      }
    }
  }

  Future<void> checkPostStatus() async {
    if(posts.isEmpty) {
      loading = true;
      try {
        posts = await _getPostService.getAllPost().timeout(Duration(seconds: 5));
        loading = false;
        emptyMessage = 'Empty List';
      } catch(e) {
        postAlert = 'Server offline. Request timeout';
        postAlertCode = 500;
        postAlertBool = true;
        loading = false;
        Timer(Duration(seconds: 5), dismissAlert);

      }
    } else {
      loading = false;
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

  Future<void> batchDelete() async {
    try {
      PostStandardResponse deleteResponse = await _getPostService.batchDelete(deleteIds);

      if(deleteResponse.httpStatusCode == 200) {
        for(int i = 0; i < deleteIds.length; i++) {
          window.localStorage.remove(deleteIds[i]);
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
  }

}