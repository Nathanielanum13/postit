

class PostStandardResponse {
  Data data;
//  Meta meta;
  int httpStatusCode;


  PostStandardResponse({this.data, this.httpStatusCode});
}

class Data {
  String id;
  String message;

  Data(this.id, this.message);
}

//class Meta {
//  String timestamp;
//  String transactionId;
//  String traceId;
//  String status;
//
//  Meta({this.timestamp, this.transactionId, this.traceId, this.status});
//}
