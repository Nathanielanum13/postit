import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/facebook_data_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_app/src/dashboard_component/widgets/filter_component/filter_component.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:quiver/time.dart';

@Component(
    selector: 'manage-post',
    templateUrl: 'manage_post_component.html',
    styleUrls: [
      'manage_post_component.css'
    ],
    directives: [
      coreDirectives,
      formDirectives,
      routerDirectives,
      MaterialCheckboxComponent,
      MaterialDatepickerComponent,
      MaterialDateRangePickerComponent,
      DateRangeInputComponent,
      FocusListDirective,
      MaterialIconComponent,
      MaterialFabComponent,
      MaterialButtonComponent,
      MaterialExpansionPanel,
      MaterialExpansionPanelAutoDismiss,
      MaterialExpansionPanelSet,
      ModalComponent,
      FilterComponent,
      AlertComponent,
    ],
    providers: [
      ClassProvider(GetPostService),
      ClassProvider(FacebookDataService),
      windowBindings,
      datepickerBindings,
      overlayBindings,
    ],
    exports: [
      InnerRoutes,
      InnerRoutePaths
    ],
    pipes: [
      commonPipes
    ])
class ManagePostComponent implements OnInit {
  final GetPostService _getPostService;
  final FacebookDataService _facebookDataService;
  Router _router;

  ManagePostComponent(
      this._getPostService, this._router, this._facebookDataService);

  Date startDate;
  Date finalDate;
  Date optionalDate;
  Date fromStart = Date.today();
  Date fromEnd = Date.today().add(years: 15);
  List<SingleDayRange> predefinedDates;
  List<DatepickerPreset> getPresets;

  List<Schedule> scheduledPosts = <Schedule>[];
  List<Post> posts = <Post>[];
  List<Post> filteredPosts = <Post>[];
  String title = '';
  String duration = '';
  String postAlert = '';
  bool postAlertBool = false;
  bool allIsChecked = false;
  bool isPosting = false;
  bool inputError = false;
  bool isRefresh = false;
  String postMessage = '';
  bool loading = false;
  bool showAccount = false;
  String emptyMessage = 'Select filters to apply';
  var appTheme;
  bool isLoading = false;
  String activeAccount = '';
  int activeAccountIndex;
  List<AccountResponseData> activeAccountLists = <AccountResponseData>[];
  Datar data;

  DatepickerComparison dateRange;
  StreamSubscription<MouseEvent> listener;
  List<String> selectedIds = <String>[];
  Alert setAlert;
  int itemsPerPage = 10;
  int currentPage = 1;
  int maxPage;
  int i;

  List<String> _fbIds = <String>[];
  List<String> _twIds = <String>[];
  List<String> _liIds = <String>[];

  List<String> get fbAccounts => _fbIds;

  List<String> get twAccounts => _twIds;

  List<String> get liAccounts => _liIds;

  Future<void> gotoPosts() async {
    _router.navigate(InnerRoutePaths.create_post.toUrl());
  }

  Future<void> gotoPostAccount() async {
    _router.navigate(InnerRoutePaths.post_account.toUrl());
  }

  void disableUsedDates(MaterialDatepickerComponent element) {
    print('${element.date}');
  }

  void collectId(int index) {
    if (activeAccountLists[index].checked) {
      switch (activeAccountIndex) {
        case 0:
          setFbIds(index);
          break;
        case 1:
          setLiIds(index);
          break;
        case 2:
          setTwIds(index);
          break;
      }
    } else {
      switch (activeAccountIndex) {
        case 0:
          removeFbIds(index);
          break;
        case 1:
          removeLiIds(index);
          break;
        case 2:
          removeTwIds(index);
          break;
      }
    }
  }

  void setFbIds(int index) => _fbIds.add(activeAccountLists[index].userId);

  void setLiIds(int index) => _liIds.add(activeAccountLists[index].userId);

  void setTwIds(int index) => _twIds.add(activeAccountLists[index].userId);

  void removeFbIds(int index) =>
      _fbIds.remove(activeAccountLists[index].userId);

  void removeLiIds(int index) =>
      _liIds.remove(activeAccountLists[index].userId);

  void removeTwIds(int index) =>
      _twIds.remove(activeAccountLists[index].userId);

  void setAccounts(int index) {
    switch (index) {
      case 0:
        getFacebookAccounts(index);
        break;
      case 1:
        getLinkedinAccounts(index);
        break;
      case 2:
        getTwitterAccounts(index);
        break;
    }
  }

  void getFacebookAccounts(int index) {
    activeAccount = 'Facebook';
    activeAccountIndex = index;
    activeAccountLists = data.facebook;
  }

  void getTwitterAccounts(int index) {
    activeAccount = 'Twitter';
    activeAccountIndex = index;
    activeAccountLists = data.twitter;
  }

  void getLinkedinAccounts(int index) {
    activeAccount = 'Linkedin';
    activeAccountIndex = index;
    activeAccountLists = data.linkedin;
  }

  void getAllFilterData(FilterData data) {
    filteredPosts = data.finalPost;
    itemsPerPage = data.selectedPostPerPage;
    loading = data.loadingState;
    setAlert = data.alert;
    Timer(Duration(seconds: 5), resetAlert);
  }

  void setDateRange() {
    print('Date range::: ${dateRange.range.asPlainRange().toString()}');
  }

  void resetAlert() {
    setAlert = null;
  }

  Future<void> postSchedule() async {
    showAccount = !showAccount;
    var doc = getDocument().getElementById('manage-app');

    if (showAccount) {
      doc.style.filter = 'blur(3px) brightness(0.9)';
      Timer(Duration(milliseconds: 100), afterClose);

      try {
        isLoading = true;
        data = await _facebookDataService.getAllAccountData();
        isLoading = false;
      } catch (e) {
        isLoading = false;
      }
    }
  }

  Future<void> finalPostSchedule() async {
    if (startDate.isBefore(finalDate) &&
        selectedIds.isNotEmpty &&
        title.isNotEmpty) {
      inputError = false;
      String from = startDate.asUtcTime().toIso8601String();
      String to = finalDate.asUtcTime().toIso8601String();

      try {
        isPosting = true;
        PostStandardResponse resp = await _getPostService.createSchedule(
            title, true, from, to, selectedIds, _fbIds, _twIds, _liIds);
        isPosting = false;
        setAlert = Alert(resp.data.message, resp.httpStatusCode);
        Timer(Duration(seconds: 5), resetAlert);

        if (resp.httpStatusCode == 200) {
          Schedule newSchedule = Schedule(title, from, to, id: resp.data.id);
          scheduledPosts.add(newSchedule);

          title = '';
          startDate = null;
          finalDate = null;

          allIsChecked = false;
          _fbIds.clear();
          _liIds.clear();
          _twIds.clear();
          getAllIds();
          disableUsedDate();
          closePopup();
        }
      } catch (e) {
        isPosting = false;
        setAlert = Alert('Failed to create schedule. Connection lost', 500);
        Timer(Duration(seconds: 5), resetAlert);
      }
    } else {
      if (startDate == finalDate) {
        inputError = true;
        setAlert = Alert('from: should not be equal to: ', 500);
        Timer(Duration(seconds: 5), resetAlert);
      } else {
        setAlert = Alert('Please check input fields', 500);
        Timer(Duration(seconds: 5), resetAlert);
      }
    }
  }

  void afterClose() {
    var doc = getDocument().getElementById('manage-app');
    listener = doc.onClick.listen((event) {
      closePopup();
    });
  }

  void closePopup() {
    getDocument().getElementById('accounts-slider').style.animationName =
        'slide-down';
    Timer(Duration(milliseconds: 300), close);
  }

  void close() {
    showAccount = false;
    var doc = getDocument().getElementById('manage-app');
    doc.style.filter = 'blur(0) brightness(1)';
    listener.cancel();
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
      PostStandardResponse deleteResponse =
          await _getPostService.deleteSchedule(id);
      setAlert =
          Alert(deleteResponse.data.message, deleteResponse.httpStatusCode);
      Timer(Duration(seconds: 5), resetAlert);

      if (deleteResponse.httpStatusCode == 200) {
        scheduledPosts.removeAt(index);
        disableUsedDate();
      }
    } catch (e) {
      setAlert = Alert('Could not delete. Server error', 500);
      Timer(Duration(seconds: 5), resetAlert);
    }
  }

  void disableUsedDate() {
    /*Date finalTo = Date.today();

    if (scheduledPosts.isNotEmpty) {
      for (int i = 0; i < scheduledPosts.length; i++) {
        List<String> to = scheduledPosts[i].to.split('T');
        to.removeLast();

        Date dTo = Date.fromTime(DateTime.parse(to[0]));

        if (dTo.isAfter(finalTo)) {
          finalTo = dTo;
        }
        fromStart = finalTo;
      }
    } else {
      fromStart = Date.today();
    }*/
  }

  @override
  Future<void> ngOnInit() async {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
    posts = await _getPostService.getAllPost();
    scheduledPosts = await _getPostService.getAllScheduledPost();
    disableUsedDate();
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
