
import 'package:flutter/cupertino.dart';

class AliyunOssClientConfig {

  /// oss-cn-shenzhen.aliyuncs.com
  final String endpoint;

  final String stsServer;

  AliyunOssClientConfig({
    @required this.endpoint,
    @required this.stsServer
  });

  Map<String, String> toMap() {
    return {
      "endpoint": this.endpoint,
      "stsServer": this.stsServer
    };
  }

}