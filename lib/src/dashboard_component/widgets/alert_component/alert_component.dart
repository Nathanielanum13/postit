import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/widgets/alert_component/alert.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'alert',
  templateUrl: 'alert_component.html',
  styleUrls: ['alert_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
  ],
)

class AlertComponent {
  @Input()
  Alert alert;

  void dismissAlert() {
    alert.show = false;
  }
}
