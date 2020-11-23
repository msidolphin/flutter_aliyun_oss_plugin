
import 'package:flutter/cupertino.dart';

class AliyunOssClientConfig {

  final String clientKey;

  /// oss-cn-shenzhen.aliyuncs.com
  final String endpoint;

  final String stsServer;

  AliyunOssClientConfig({
    @required this.endpoint,
    this.clientKey,
    @required this.stsServer
  });

  Map<String, String> toMap() {
    return {
      "endpoint": this.endpoint,
      "clientKey": this.clientKey,
      "stsServer": this.stsServer
    };
  }

}