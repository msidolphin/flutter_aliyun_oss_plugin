
import 'dart:async';

import 'package:aliyun_oss/client_config.dart';
import 'package:aliyun_oss/put_object_request.dart';
import 'package:aliyun_oss/put_object_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AliyunOssClient {

  static const MethodChannel _channel =
      const MethodChannel('io.github/aliyun_oss');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<AliyunOssClient> getInstance({@required AliyunOssClientConfig config}) async {
    await _channel.invokeMethod("init", config.toMap());
    return AliyunOssClient();
  }

  /// 简单文件上传
  Future<PutObjectResult> putObjectSync(AliyunOssPutObjectRequest putObjectRequest) async {
    final result = await _channel.invokeMethod("putObjectSync", putObjectRequest.toMap());
    return new PutObjectResult.fromJson(result);
  }

}

