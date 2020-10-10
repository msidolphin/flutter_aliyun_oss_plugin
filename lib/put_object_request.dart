
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class AliyunOssPutObjectRequest {

  /// 支持路径
  final String file;
  final String bucketName;
  final String objectName;

  AliyunOssPutObjectRequest({
    @required this.file,
    @required this.bucketName,
    this.objectName
  });

  Map<String, dynamic> toMap() {
    return {
      "file": this.file,
      "bucketName": this.bucketName,
      "objectName": this.objectName,
    };
  }


}