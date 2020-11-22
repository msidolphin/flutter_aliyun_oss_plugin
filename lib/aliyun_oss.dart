
import 'dart:async';

import 'package:aliyun_oss/client_config.dart';
import 'package:aliyun_oss/put_object_event_handler.dart';
import 'package:aliyun_oss/put_object_progress.dart';
import 'package:aliyun_oss/put_object_request.dart';
import 'package:aliyun_oss/put_object_response.dart';
import 'package:aliyun_oss/put_object_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AliyunOssClient {

  String _clientKey;

  static Map<String, PutObjectEventHandler> handlers = new Map();

  static MethodChannel _channel =
      const MethodChannel('io.github/aliyun_oss')..setMethodCallHandler(_methodHandler);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<AliyunOssClient> getInstance({@required AliyunOssClientConfig config}) async {
    await _channel.invokeMethod("init", config.toMap());
    AliyunOssClient aliyunOssClient = new AliyunOssClient();
    aliyunOssClient._clientKey = config.clientKey;
    return aliyunOssClient;
  }

  /// 简单文件上传（同步）废弃
  @deprecated
  Future<PutObjectResult> putObjectSync(AliyunOssPutObjectRequest putObjectRequest) async {
    final result = await _channel.invokeMethod("putObjectSync", {
      ...putObjectRequest.toMap(),
      "clientKey": _clientKey
    });
    return new PutObjectResult.fromJson(result);
  }

  /// 简单文件上传
  Future<PutObjectEventHandler> putObject(AliyunOssPutObjectRequest putObjectRequest) async {
    String taskId = await _channel.invokeMethod("putObject", {
      ...putObjectRequest.toMap(),
      "clientKey": _clientKey
    });
    PutObjectEventHandler handler = new PutObjectEventHandler(taskId: taskId);
    handlers[taskId] = handler;
    return handler;
  }

  static Future _methodHandler(MethodCall call) {
    final result = call.arguments;
    final taskId = result['taskId'];
    final handler = handlers[taskId];
    if (handler == null) return Future.value();
    switch(call.method) {
      case 'onProgress':
        handler.controller.sink.add(new PutObjectResponse(progress: new PutObjectProgress(
          currentSize: result['currentSize'],
          totalSize: result['totalSize'],
        )));
        break;
      default:
        handler.controller.sink.add(new PutObjectResponse(result: new PutObjectResult.fromJson(result['result'])));
    }
    return Future.value();
  }

  void disposeHandler(String taskId) {
    final handler = handlers[taskId];
    if (handler != null) {
      handler.dispose();
      handlers.remove(taskId);
    }
  }

  void dispose() {
    handlers.clear();
  }

}

