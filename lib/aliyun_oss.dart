
import 'dart:async';

import 'package:aliyun_oss/client_config.dart';
import 'package:aliyun_oss/put_object_event_handler.dart';
import 'package:aliyun_oss/put_object_request.dart';
import 'package:aliyun_oss/put_object_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const String CLIENT_KEY = "primary";

class AliyunOssClient {

  static String _clientKey = CLIENT_KEY;

  static MethodChannel _channel =
      const MethodChannel('io.github/aliyun_oss')..setMethodCallHandler(_methodHandler);

  static Map<String, PutObjectEventHandler> _handlers = {};

  static final StreamController<PutObjectResult> _streamController = new StreamController<PutObjectResult>.broadcast();

  static Future<AliyunOssClient> init({@required AliyunOssClientConfig config}) async {
    await _channel.invokeMethod("init", config.toMap());
    AliyunOssClient aliyunOssClient = new AliyunOssClient();
    _streamController.stream.listen((event) {
      final handler = _handlers[event.taskId];
      if (handler != null) {
        handler.dispatch(event);
        _handlers.remove(event.taskId);
      }
    });
    return aliyunOssClient;
  }

  /// 简单文件上传
  Future<PutObjectEventHandler> putObject(AliyunOssPutObjectRequest putObjectRequest) async {
    String taskId = await _channel.invokeMethod("putObject", {
      ...putObjectRequest.toMap(),
      "clientKey": _clientKey
    });
    final PutObjectEventHandler handler = new PutObjectEventHandler(
      taskId: taskId
    );
    _handlers[taskId] = handler;
    return handler;
  }

  static Future _methodHandler(MethodCall call) {
    final result = call.arguments;
    final taskId = result['taskId'];
    switch(call.method) {
      case 'onProgress':
        _streamController.sink.add(new PutObjectResult(
          taskId: taskId,
          url: '',
          currentSize: result['currentSize'],
          totalSize: result['totalSize']
        ));
        break;
      case 'onSuccess':
        _streamController.sink.add(new PutObjectResult(
          taskId: taskId,
          url: result['url']
        ));
        break;
      case 'onFailure':
        _streamController.sink.add(new PutObjectResult(
          taskId: taskId,
          errorMessage: result['errorMessage']
        ));
    }
    return Future.value();
  }

  void dispose() {
    _streamController.close();
    _handlers.clear();
  }

}

