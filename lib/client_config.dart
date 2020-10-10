
import 'package:flutter/cupertino.dart';

class AliyunOssClientConfig {

  /// oss-cn-shenzhen.aliyuncs.com
  final String endpoint;

  final String accessKeyId;

  final String accessKeySecret;

  AliyunOssClientConfig({
    @required this.endpoint,
    @required this.accessKeyId,
    @required this.accessKeySecret
  });

  Map<String, String> toMap() {
    return {
      "endpoint": this.endpoint,
      "accessKeyId": this.accessKeyId,
      "accessKeySecret": this.accessKeySecret,
    };
  }

}