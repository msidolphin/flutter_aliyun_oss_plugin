package io.github.aliyun_oss;

import android.content.Context;

import androidx.annotation.NonNull;


import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.github.aliyun_oss.entity.AliyunPutObjectResult;

/** AliyunOssPlugin */
public class AliyunOssPlugin implements FlutterPlugin, MethodCallHandler {

  private Context context;

  private MethodChannel channel;

  private static AliyunOssClient ossClient;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "io.github/aliyun_oss");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("init")) {
      String endpoint = call.argument("endpoint");
      String accessKeyId = call.argument("accessKeyId");
      String accessKeySecret = call.argument("accessKeySecret");
      ossClient = new AliyunOssClient(context, new AliyunOssClientConfig(endpoint, accessKeyId, accessKeySecret
      ), new AliyunOssClientConnectConfig(null, null, null, null));
      result.success(true);
    } else if (call.method.equals("putObjectSync")) {
      String bucketName = call.argument("bucketName");
      String objectName = call.argument("objectName");
      String filePath = call.argument("file");
      AliyunPutObjectResult putObjectResult = ossClient.putObjectSync(bucketName, objectName, filePath);
      result.success(putObjectResult.toMap());
    } else if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

}
