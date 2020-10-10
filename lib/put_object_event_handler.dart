import 'dart:async';

import 'package:aliyun_oss/put_object_response.dart';
import 'package:aliyun_oss/put_object_result.dart';
import 'package:flutter/cupertino.dart';

typedef OnPutObjectSuccess = void Function(PutObjectResult result);

typedef OnPutObjectFailure = void Function(PutObjectResult result);

typedef OnPutObjectProgress = void Function(int currentSize, int totalSize, double progress);

class PutObjectEventHandler {

  final StreamController<PutObjectResponse> controller = new StreamController<PutObjectResponse>.broadcast();

  final String taskId;

  OnPutObjectSuccess onSuccess;
  OnPutObjectFailure onFailure;
  OnPutObjectProgress onProgress;

  bool isDispose = false;


  PutObjectEventHandler({@required this.taskId}) {
    controller.stream.listen((event) {
      if (isDispose) return;
      if (event.result != null) {
        if (event.result.isSuccess) onSuccess?.call(event.result);
        else onFailure?.call(event.result);
      }
      if (event.progress != null) {
        onProgress?.call(event.progress.currentSize, event.progress.totalSize, event.progress.progress);
      }
    });
  }

  void dispose() {
    if (isDispose) return;
    controller?.close();
    isDispose = true;
  }

}