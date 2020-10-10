import 'package:aliyun_oss/put_object_progress.dart';
import 'package:aliyun_oss/put_object_result.dart';

class PutObjectResponse {

  final PutObjectResult result;

  final PutObjectProgress progress;

  PutObjectResponse({this.result, this.progress});

}