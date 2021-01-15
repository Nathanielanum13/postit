import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/utils/browser/window/module.dart';

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
  selector: 'manage-post',
  templateUrl: 'manage_post_component.html',
  styleUrls: ['manage_post_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    routerDirectives,
    MaterialCheckboxComponent,
    MaterialDatepickerComponent,
    DateRangeInputComponent,
    FocusListDirective,
    MaterialIconComponent,
    MaterialFabComponent,
    MaterialButtonComponent,
    MaterialExpansionPanel,
    MaterialExpansionPanelAutoDismiss,
    MaterialExpansionPanelSet,
    ModalComponent,
  ],
  providers: [
    ClassProvider(GetPostService),
    windowBindings, datepickerBindings,
    overlayBindings
  ],
  exports: [InnerRoutes, InnerRoutePaths]
)
class ManagePostComponent implements OnInit {
  final GetPostService _getPostService;
  ManagePostComponent(this._getPostService);

  Date startDate;
  Date finalDate;
  Date optionalDate;
  Date fromStart = Date.today();
  Date fromEnd = Date.today().add(years: 15);
  List<SingleDayRange> predefinedDates;

  List<Schedule> scheduledPosts = <Schedule>[];
  List<Post> posts = <Post>[];
  List<Post> filteredPosts = <Post>[];
  List<String> postIds = <String>[];
  String selectedFilter = '';
  String selectedNumber = '';

  List<String> get filters => _filters;
  List<String> get numbers => _numbers;
  String title = '';
  String duration = '';
  String postAlert = '';
  bool postAlertBool = false;
  bool allIsChecked = false;
  bool isPosting = false;
  bool inputError = false;
  bool isRefresh = false;
  bool createNeed = false;
  bool saveCancel = false;
  int postAlertCode = 0;
  String postMessage = '';
  bool loading = false;
  String emptyMessage = 'Select filters to apply';


  Future<void> postSchedule() async {

    if(startDate.isBefore(finalDate) && postIds.isNotEmpty && title.isNotEmpty) {
      inputError = false;
      String from = startDate.asUtcTime().toIso8601String();
      String to = finalDate.asUtcTime().toIso8601String();

      try {
        PostStandardResponse resp = await _getPostService.createSchedule(title, true, from, to, postIds);
        postAlert = resp.data.message;
        postAlertCode = resp.httpStatusCode;
        postAlertBool = true;
        Timer(Duration(seconds: 5), dismissAlert);

        if(resp.httpStatusCode == 200) {
          Schedule newSchedule = Schedule(title, from, to, id: resp.data.id);
          scheduledPosts.add(newSchedule);

          title = '';
          startDate = null;
          finalDate = null;

          allIsChecked = false;
          getAllIds();
          disableUsedDate();
        }
      } catch(e) {
        postAlert = 'Could not create. Server offline';
        postAlertCode = 500;
        postAlertBool = true;
        Timer(Duration(seconds: 5), dismissAlert);
      }

    } else {
      if(startDate == finalDate) {
        postAlert = 'from: should not be equal to: ';
        postAlertCode = 500;
        postAlertBool = true;
        inputError = true;
        Timer(Duration(seconds: 5), dismissAlert);
      } else {
        postAlert = 'Invalid parameter. Check input fields';
        postAlertCode = 500;
        postAlertBool = true;
        Timer(Duration(seconds: 5), dismissAlert);
      }

    }

  }

  void dismissAlert() {
    postAlertBool = false;
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
    }
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
    postIds.clear();
    if(allIsChecked) {
      for(int i = 0; i < filteredPosts.length; i++) {
        filteredPosts[i].checkedState = true;
        postIds.add(filteredPosts[i].id);
      }
    } else {
      for(int i = 0; i < filteredPosts.length; i++) {
        filteredPosts[i].checkedState = false;
        postIds.remove(filteredPosts[i].id);
      }
    }

  }

  void getId(int index) {
    if(filteredPosts[index].checkedState) {
      postIds.add(posts[index].id);
    } else {
      postIds.remove(posts[index].id);
    }
  }

  MaterialDatepickerDemoComponent() {
    var clock = Clock();
    predefinedDates = <SingleDayRange>[
      today(clock),
      yesterday(clock),
    ];
  }

  Future<void> remove(int index) async {
    String id = scheduledPosts[index].id;
    try {
      PostStandardResponse deleteResponse = await _getPostService.deleteSchedule(id);

      postAlert = deleteResponse.data.message;
      postAlertCode = deleteResponse.httpStatusCode;
      postAlertBool = true;
      Timer(Duration(seconds: 5), dismissAlert);

      if(deleteResponse.httpStatusCode == 200) {
        scheduledPosts.removeAt(index);
        disableUsedDate();
      }
    } catch(e) {
      postAlert = 'Could not delete. Server error';
      postAlertCode = 500;
      postAlertBool = true;
      Timer(Duration(seconds: 5), dismissAlert);
    }

  }

  void disableUsedDate() {
    Date finalTo = Date.today();

    if(scheduledPosts.isNotEmpty) {
      for(int i = 0; i < scheduledPosts.length; i++) {
        List<String> to = scheduledPosts[i].to.split('T');
        to.removeLast();

        Date dTo = Date.fromTime(DateTime.parse(to[0]));

        if(dTo.isAfter(finalTo)) {
          finalTo = dTo;
        }
        fromStart = finalTo;
      }
    } else {
      fromStart = Date.today();
    }
  }

  @override
  Future<void> ngOnInit() async {
    posts = await _getPostService.getAllPost();
    scheduledPosts = await _getPostService.getAllScheduledPost();
    disableUsedDate();
  }

}