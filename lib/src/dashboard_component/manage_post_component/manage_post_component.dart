import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_app/src/dashboard_component/inner_routes.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert_component.dart';
import 'package:angular_app/src/dashboard_component/widgets/filter_component/filter_component.dart';
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
    windowBindings, datepickerBindings,
    overlayBindings,
  ],
  exports: [InnerRoutes, InnerRoutePaths],
  pipes: [commonPipes]
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
  String activeAccount = 'Facebook';

  DatepickerComparison dateRange;
  StreamSubscription<MouseEvent> listener;
  List<String> selectedIds = <String>[];
  Alert setAlert;
  int itemsPerPage = 10;
  int currentPage = 1;
  int maxPage;
  int i;

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

  void getPresetsOnPageLoad() {
      getPresets.add(DatepickerPreset('Today', DatepickerDateRange('Today', Date(2021, 3, 1), Date(2021, 3, 25))));
  }

  Future<void> postSchedule() async {
    showAccount = !showAccount;
    var doc = getDocument().getElementById('manage-app');

    if(showAccount) {
      doc.style.filter = 'blur(3px) brightness(0.9)';
      Timer(Duration(milliseconds: 100), afterClose);
    }
    /*if(startDate.isBefore(finalDate) && selectedIds.isNotEmpty && title.isNotEmpty) {
      inputError = false;
      String from = startDate.asUtcTime().toIso8601String();
      String to = finalDate.asUtcTime().toIso8601String();

      try {
        isPosting = true;
        PostStandardResponse resp = await _getPostService.createSchedule(title, true, from, to, selectedIds);
        isPosting = false;
        setAlert = Alert(resp.data.message, resp.httpStatusCode);
        Timer(Duration(seconds: 5), resetAlert);

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
        isPosting = false;
        setAlert = Alert('Could not create. Server offline', 500);
        Timer(Duration(seconds: 5), resetAlert);
      }

    } else {
      if(startDate == finalDate) {
        inputError = true;
        setAlert = Alert('from: should not be equal to: ', 500);
        Timer(Duration(seconds: 5), resetAlert);
      } else {
        setAlert = Alert('Invalid parameter. Check input fields', 500);
        Timer(Duration(seconds: 5), resetAlert);
      }

    }*/

  }

  void afterClose() {
    var doc = getDocument().getElementById('manage-app');
    listener = doc.onClick.listen((event) {
      closePopup();
    });
  }
  void closePopup() {
    getDocument().getElementById('accounts-slider').style.animationName = 'slide-down';
    Timer(Duration(milliseconds: 500), close);
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
    if(allIsChecked) {
      for(int i = 0; i < filteredPosts.length; i++) {
        filteredPosts[i].checkedState = true;
        selectedIds.add(filteredPosts[i].id);
      }
    } else {
      for(int i = 0; i < filteredPosts.length; i++) {
        filteredPosts[i].checkedState = false;
        selectedIds.remove(filteredPosts[i].id);
      }
    }
  }

  void getId(int index) {
    index = ((currentPage - 1) * itemsPerPage) + index;
    !filteredPosts[index].checkedState;
    if(filteredPosts[index].checkedState) {
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
      PostStandardResponse deleteResponse = await _getPostService.deleteSchedule(id);
      setAlert = Alert(deleteResponse.data.message, deleteResponse.httpStatusCode);
      Timer(Duration(seconds: 5), resetAlert);

      if(deleteResponse.httpStatusCode == 200) {
        scheduledPosts.removeAt(index);
        disableUsedDate();
      }
    } catch(e) {
      setAlert = Alert('Could not delete. Server error', 500);
      Timer(Duration(seconds: 5), resetAlert);
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
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
    posts = await _getPostService.getAllPost();
    scheduledPosts = await _getPostService.getAllScheduledPost();
    disableUsedDate();
    getPresetsOnPageLoad();
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
    this.maxPage = (filteredPosts.length/conv(itemsPerPage)).ceil();
    List ret = [];
    for (var i=1; i<=this.maxPage; i++) {
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