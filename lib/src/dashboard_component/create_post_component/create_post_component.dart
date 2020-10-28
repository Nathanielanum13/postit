import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/src/dashboard_component/create_post_component/csv_upload_component/csv_upload_component.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/create_post_service.dart';
import 'package:angular_app/src/dashboard_component/dashboard_services/models.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:emojis/emoji.dart';


@Component(
  selector: 'create-post',
  templateUrl: 'create_post_component.html',
  styleUrls: ['create_post_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialCheckboxComponent,
    FixedMaterialTabStripComponent,
    MaterialToggleComponent,
    MaterialChipComponent,
    MaterialChipsComponent,
    MaterialToggleComponent,
    CsvUploadComponent,
  ],
  providers: [ClassProvider(GetPostService)],
)
class CreatePostComponent implements OnInit{
  final GetPostService _getPostService;

  String postAlert = ' ';
  bool postAlertBool = false;
  bool editKey = false;
  bool toggleState = false;
  bool allIsChecked = false;
  int postAlertCode = 0;

  String postMessage = '';
  String hashtag = '';
  String imageFile, fileFile = 'Select file to upload...';
  List<int> postImage;

  List<String> postTags = <String>[];
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

  List<String> deleteIds = <String>[];
  List<Post> currentPosts = <Post>[];
  String fileName = '';
  String _updatePostId = '';
  String funcCall = '';
  int _updatePostIndex;
  int insertPosition;
  String imgPath = '';



  CreatePostComponent(this._getPostService);


  Future<void> handleUpload(Event event) async {
    event.preventDefault();

    File pic = (event.target as FileUploadInputElement).files[0];
    fileName = pic.name;

    var reader = FileReader()
      ..readAsDataUrl(pic);

    await reader.onLoadEnd.first;
    imgPath = reader.result;


    var r = FileReader()
      ..readAsArrayBuffer(pic);

    await r.onLoadEnd.first;
    List<int> result = r.result;

    byteToString(result);

  }

  void getAllIds() {
    deleteIds.clear();
    if(allIsChecked) {
      for(int i = 0; i < currentPosts.length; i++) {
        currentPosts[i].checkedState = true;
        deleteIds.add(currentPosts[i].id);
      }
    } else {
      for(int i = 0; i < currentPosts.length; i++) {
        currentPosts[i].checkedState = false;
        deleteIds.remove(currentPosts[i].id);
      }
    }

  }

  void getId(int index) {
    if(currentPosts[index].checkedState) {
      deleteIds.add(currentPosts[index].id);
    } else {
      deleteIds.remove(currentPosts[index].id);
    }
    print(deleteIds.toString());
  }

  Future<void> batchDelete() async {
    print('Batch Delete Method');
    try {
      PostStandardResponse deleteResponse = await _getPostService.batchDelete(deleteIds);
      postAlert = deleteResponse.data.message;
      postAlertCode =deleteResponse.httpStatusCode;
      postAlertBool = true;
      Timer(Duration(seconds: 5), dismissAlert);


      if(deleteResponse.httpStatusCode == 200) {
        for(int i = 0; i < deleteIds.length; i++) {
          window.localStorage.remove(deleteIds[i]);
          currentPosts.remove(stringToPost(deleteIds[i]));
        }
      }
      deleteIds.clear();
      allIsChecked = false;
    } catch(e) {
      postAlert = 'Could not delete. Server offline';
      postAlertCode = 500;
      postAlertBool = true;
      Timer(Duration(seconds: 5), dismissAlert);

    }
  }

  Post stringToPost(String st) {
    Post deletePost;
    for(int i = 0; i < currentPosts.length; i++) {
      if(currentPosts[i].id == st) {
         deletePost = currentPosts[i];
      }
    }
    return deletePost;
  }


  void getInputSelection(InputElement el) {
    var endPosition = el.selectionEnd;
    var startPosition = el.selectionStart;

    print('Start: $startPosition, End: $endPosition');
    insertPosition =  endPosition;
  }

  void arrangePostMessage(String emoValue) {
    List<String> postMessageList = <String>[];

    if(postMessage.isNotEmpty) {
      for(int i = 0; i < postMessage.length; i++) {
        postMessageList.add(postMessage[i]);
      }
      postMessageList.insert(insertPosition, emoValue);
      insertPosition += 2;
    } else {
      postMessage = postMessage + emoValue;
      postMessageList.add(postMessage);
    }

    postMessage = '';

    for(int i = 0; i < postMessageList.length; i++) {
      postMessage = postMessage + postMessageList[i];
    }
  }

  void getEmotionValue(int index) {
    String emoValue = smileyEmotions.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void getFlagValue(int index) {
    String emoValue = flags.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void getTravelPlacesValue(int index) {
    String emoValue = travelPlaces.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void getAnimalsValue(int index) {
    String emoValue = animalNatures.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void getActivitiesValue(int index) {
    String emoValue = activities.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void getObjectsValue(int index) {
    String emoValue = objects.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void getFoodDrinksValue(int index) {
    String emoValue = foodDrinks.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void getComponentValue(int index) {
    String emoValue = components.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void getPeopleBodyValue(int index) {
    String emoValue = peopleBodys.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void getSymbolsValue(int index) {
    String emoValue = symbols.elementAt(index).toString();
    arrangePostMessage(emoValue);
  }

  void byteToString(List<int> s) {
    print(s);
    postImage = s;
  }

  Future<void> addPost() async {
    postMessage = postMessage.trim();
      if (postMessage.isEmpty) return null;

      try {
        PostStandardResponse resp = await _getPostService.create(postMessage, tags: postTags, image: postImage, priority: toggleState);
        postAlert = resp.data.message;
        postAlertCode = resp.httpStatusCode;
        postAlertBool = true;

        Timer(Duration(seconds: 5), dismissAlert);



        if(resp.httpStatusCode == 200) {
          Post newPost = Post(postMessage, postTag: postTags, id: resp.data.id, postImage: postImage, postPriority: toggleState);

          currentPosts.add(newPost);
          savePost(newPost);

          postMessage = '';
          postTags.clear();
          toggleState = false;
        }
      } catch(e) {
        postAlert = 'Could not create. Server offline';
        postAlertCode = 500;
        postAlertBool = true;
        Timer(Duration(seconds: 5), dismissAlert);


      }
  }

  Future<void> updatePost() async {
    postMessage = postMessage.trim();
    if (postMessage.isEmpty) return null;

    try {
      PostStandardResponse resp = await _getPostService.update(_updatePostId ,postMessage, postTags, postImage);
      postAlert = resp.data.message;
      postAlertCode = resp.httpStatusCode;
      postAlertBool = true;
      Timer(Duration(seconds: 5), dismissAlert);



      print(resp.httpStatusCode);

      if(resp.httpStatusCode == 200) {
        Post newPost = Post(postMessage, postTag: postTags, id: resp.data.id, postImage: postImage);

        currentPosts.removeAt(_updatePostIndex);
        currentPosts.insert(_updatePostIndex, newPost);

        savePost(newPost);

        postMessage = '';
        postTags.clear();
      }

      editKey = false;

    } catch(e) {
      postAlert = 'Could not edit. Server offline';
      postAlertCode = 500;
      postAlertBool = true;
      Timer(Duration(seconds: 5), dismissAlert);


    }
  }


  Future<void> remove(int index) async {
    String id = currentPosts[index].id;
    try {
      PostStandardResponse deleteResponse = await _getPostService.delete(id);

      postAlert = deleteResponse.data.message;
      postAlertCode = deleteResponse.httpStatusCode;
      postAlertBool = true;
      Timer(Duration(seconds: 5), dismissAlert);



      if(deleteResponse.httpStatusCode == 200) {
        window.localStorage.remove(id);
        currentPosts.removeAt(index);
      }
    } catch(e) {
      postAlert = 'Could not delete. Server error';
      postAlertCode = 500;
      postAlertBool = true;
      Timer(Duration(seconds: 5), dismissAlert);

    }

  }

  void removeTag(int index) => postTags.removeAt(index);

  void dismissAlert() {
    postAlertBool = false;
  }

  void addTag() {
    postTags.add(hashtag);
    hashtag = '';
  }

  void savePost(Post new_post) {
    Storage localStorage = window.localStorage;
    var keyId = new_post.id;

    var post = {
      'id' : new_post.id,
      'post_message' : new_post.postMessage,
      'hash_tags' : new_post.postTag,
      'post_image' : new_post.postPic,
      'post_priority' : new_post.postPriority,
    };
    localStorage['$keyId'] = json.encode(post);
  }

  List<Post> fetchPost() {
    Storage ls = window.localStorage;
    List<Post> posts = <Post>[];

    for(int i = 0; i < ls.values.length; i++) {
      var d = json.decode(ls.values.elementAt(i));

      Post newPost = Post(
          d['post_message'],
          id: d['id'],
          postTag: convertLDS(d['hash_tags']),
          postPic: d['post_image']
      );
      posts.add(newPost);
    }
    return posts;
  }

  void editPost(int index) {
    String s = index.toString();

    var a = getDocument().getElementById(s);
    print(a.getAttribute('class'));
    String ng = '';
    for(int i = 11; i < a.getAttribute('class').length; i++) {
      ng = ng + a.getAttribute('class')[i];
    }
    print(ng);

    if(a.getAttribute('class') == 'fa fa-edit $ng') {
      editKey = true;
      a.setAttribute('class', 'fa fa-tice $ng');
    } else if(a.getAttribute('class') == 'fa fa-tice $ng') {
      editKey = false;
      a.setAttribute('class', 'fa fa-edit $ng');
    }

    var post_id = currentPosts[index].id;
    Storage editLocal = window.localStorage;
    var decodedJson = json.decode(editLocal['$post_id']);

    postMessage = decodedJson['post_message'];
    postTags = convertLDS(decodedJson['hash_tags']);
    postImage = decodedJson['post_image'];
    toggleState = decodedJson['post_priority'];

    _updatePostId = post_id;
    _updatePostIndex = index;
  }


  @override
  void ngOnInit() {
    // TODO: implement
    currentPosts = fetchPost();
  }
}
