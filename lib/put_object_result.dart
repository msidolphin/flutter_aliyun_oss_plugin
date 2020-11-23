class PutObjectResult {

  final String url;
  final String taskId;
  final int currentSize;
  final int totalSize;
  final String errorMessage;

  PutObjectResult({this.url, this.taskId, this.currentSize, this.totalSize, this.errorMessage, });

  bool get isFinished  => url != null && url.trim().isNotEmpty;

  bool get isError => errorMessage != null && errorMessage.trim().isNotEmpty;

  @override
  String toString() {
    return 'PutObjectResult{url: $url, taskId: $taskId, currentSize: $currentSize, totalSize: $totalSize, errorMessage: $errorMessage}';
  }


//  PutObjectResult({this.url, this.requestId, this.statusCode, this.errorCode, this.message, this.eTag, this.isSuccess});
//
//  factory PutObjectResult.fromJson(final json) {
//    return PutObjectResult(url: json["url"],
//      requestId: json["requestId"],
//      statusCode: int.parse(json["statusCode"].toString()),
//      errorCode: json["errorCode"],
//      message: json["message"],
//      eTag: json["eTag"],
//      isSuccess: json['isSuccess']);
//  }

}