import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:aliyun_oss/aliyun_oss.dart';
import 'package:aliyun_oss/client_config.dart';
import 'package:aliyun_oss/put_object_request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _platformVersion = 'Unknown';

  final ImagePicker _picker = ImagePicker();

  String text = "";

  String imgUrl;

  double _precent1 = 0;
  double _precent2 = 0;

  AliyunOssClient ossClient;
  
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AliyunOssClient.platformVersion;
      ossClient = await AliyunOssClient.getInstance(config: new AliyunOssClientConfig(
        accessKeyId: "LTAI4Fu648e9AGBEJZUWu3cw",
        accessKeySecret: "cWfMm8OanF1aEGHvj1aZ2ODBCGi8MV",
        endpoint: "oss-accelerate.aliyuncs.com",
        clientKey: "client-key",
        stsServer: 'http://192.168.0.55:89/hero/app/sbs/home/getAliyunSTSToken'
      ));
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: GlobalKey(),
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (context) {
            return ListView(
              children: [
                FlatButton(onPressed: () {
                  _picker.getImage(source: ImageSource.gallery).then((PickedFile file) {
                    Future.delayed(Duration(milliseconds: 60), () async {
                      final start = DateTime.now();
                      final result = await ossClient.putObjectSync(AliyunOssPutObjectRequest(
                          bucketName: 'gdjcywebdata001',
                          file: file.path
                      ));
                      final end = DateTime.now();
                      text = "上传成功：${result.url} 共耗时：${end.millisecondsSinceEpoch - start.millisecondsSinceEpoch}ms";
                      imgUrl = result.url;
                      setState(() {

                      });
                    });
                  });
                }, child: Text('同步上传【不推荐使用】')),
                FlatButton(onPressed: () {
                  _picker.getImage(source: ImageSource.gallery).then((PickedFile file) {
                    Future.delayed(Duration(milliseconds: 60), () async {
                      _precent1 = 0;
                      setState(() {

                      });
                      final handler = await ossClient.putObject(AliyunOssPutObjectRequest(
                          bucketName: 'gdjcywebdata001',
                          file: file.path
                      ));
                      handler.onProgress = (currentSize, totalSize, progress) {
                        _precent1 = currentSize / totalSize;
                        if (_precent1 >= 1) _precent1 = 0.9999;
                        setState(() {

                        });
                      };
                      handler.onSuccess = (result) {
                        _precent1 = 1;
                        setState(() {

                        });
                        ossClient.disposeHandler(handler.taskId);
                      };
                      handler.onFailure = (result) {
                        ossClient.disposeHandler(handler.taskId);
                      };
                    });
                  });
                }, child: Text('异步上传1')),
                new LinearPercentIndicator(
                  percent: _precent1,
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
                FlatButton(onPressed: () {
                  _picker.getImage(source: ImageSource.gallery).then((PickedFile file) {
                    Future.delayed(Duration(milliseconds: 60), () async {
                      _precent2 = 0;
                      setState(() {

                      });
                      final handler = await ossClient.putObject(AliyunOssPutObjectRequest(
                          bucketName: 'gdjcywebdata001',
                          file: file.path
                      ));
                      handler.onProgress = (currentSize, totalSize, progress) {
                        _precent2 = currentSize / totalSize;
                        if (_precent2 >= 1) _precent2 = 0.9999;
                        setState(() {

                        });
                      };
                      handler.onSuccess = (result) {
                        _precent2 = 1;
                        setState(() {

                        });
                        ossClient.disposeHandler(handler.taskId);
                      };
                      handler.onFailure = (result) {
                        ossClient.disposeHandler(handler.taskId);
                      };
                    });
                  });
                }, child: Text('异步上传2')),
                new LinearPercentIndicator(
                  percent: _precent2,
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
                SizedBox(height: 8,),
                Center(
                  child: Text('Running on: $_platformVersion\n'),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(text)
                ),
                imgUrl != null ? CachedNetworkImage(imageUrl: imgUrl) : SizedBox(height: 0,)
              ],
            );
          },
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    ossClient.dispose();
  }

}
