class PostStandardResponse {
  Data data;
  int httpStatusCode;


  PostStandardResponse({this.data, this.httpStatusCode});
}

class Data {
  String id;
  String message;

  Data(this.id, this.message);
}

