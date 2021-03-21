import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:emojis/emoji.dart';

@Component(
  selector: 'emoji-app',
  templateUrl: 'emojis_component.html',
  styleUrls: ['emojis_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
  ],
)
class EmojisComponent implements OnInit {
  Iterable<Emoji> smileyEmotions = Emoji.byGroup(EmojiGroup.smileysEmotion);
  Iterable<Emoji> travelPlaces = Emoji.byGroup(EmojiGroup.travelPlaces);
  Iterable<Emoji> animalNatures = Emoji.byGroup(EmojiGroup.animalsNature);
  Iterable<Emoji> activities = Emoji.byGroup(EmojiGroup.activities);
  Iterable<Emoji> components = Emoji.byGroup(EmojiGroup.component);
  Iterable<Emoji> flags = Emoji.byGroup(EmojiGroup.flags);
  Iterable<Emoji> foodDrinks = Emoji.byGroup(EmojiGroup.foodDrink);
  Iterable<Emoji> objects = Emoji.byGroup(EmojiGroup.objects);
  Iterable<Emoji> peopleBodys = Emoji.byGroup(EmojiGroup.peopleBody);
  Iterable<Emoji> symbols = Emoji.byGroup(EmojiGroup.symbols);
  var appTheme;
  String emoValue = '';
  final _myEvent = StreamController<String>();
  @Output('myClick')
  Stream<String> get myEvent => _myEvent.stream;

  void getEmotionValue(int index) {
    emoValue = smileyEmotions.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  void getFlagValue(int index) {
    emoValue = flags.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  void getTravelPlacesValue(int index) {
    emoValue = travelPlaces.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  void getAnimalsValue(int index) {
    emoValue = animalNatures.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  void getActivitiesValue(int index) {
    emoValue = activities.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  void getObjectsValue(int index) {
    emoValue = objects.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  void getFoodDrinksValue(int index) {
    emoValue = foodDrinks.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  void getComponentValue(int index) {
    emoValue = components.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  void getPeopleBodyValue(int index) {
    emoValue = peopleBodys.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  void getSymbolsValue(int index) {
    emoValue = symbols.elementAt(index).toString();
    _myEvent.add(emoValue);
  }

  @override
  void ngOnInit() {
    appTheme = json.decode(window.localStorage['x-user-preference-theme']);
  }
}