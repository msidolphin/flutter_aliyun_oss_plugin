import 'dart:async';

import 'package:aliyun_oss/put_object_result.dart';

typedef OnUploadSuccess = void Function(String url);

typedef OnUploadFailure = void Function(String message);

typedef OnProgress = void Function(int currentSize, int totalSize);

class PutObjectEventHandler {

  final String taskId;

  PutObjectEventHandler({this.taskId});

  void dispatch(PutObjectResult event) {
    print(event.taskId);
    if (event.taskId != taskId) return;
    if (event.isFinished) {
      onSuccess?.call(event.url);
    } else if (event.isError) {
      onFailure?.call(event.errorMessage);
    } else {
      onProgress?.call(event.currentSize, event.totalSize);
    }
  }

  OnUploadSuccess onSuccess;
  OnUploadFailure onFailure;
  OnProgress onProgress;

}