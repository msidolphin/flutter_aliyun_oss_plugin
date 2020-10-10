class PutObjectResult {

  final String url;
  final String requestId;
  final int statusCode;
  final String errorCode;
  final String message;
  final String eTag;

  PutObjectResult({this.url, this.requestId, this.statusCode, this.errorCode, this.message, this.eTag});

  factory PutObjectResult.fromJson(final json) {
    return PutObjectResult(url: json["url"],
      requestId: json["requestId"],
      statusCode: int.parse(json["statusCode"].toString()),
      errorCode: json["errorCode"],
      message: json["message"],
      eTag: json["eTag"],);
  }

}