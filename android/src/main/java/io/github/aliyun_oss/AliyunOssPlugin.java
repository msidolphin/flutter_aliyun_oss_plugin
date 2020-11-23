package io.github.aliyun_oss;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;


import com.alibaba.sdk.android.oss.model.PutObjectRequest;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.github.aliyun_oss.entity.AliyunPutObjectResult;
import io.github.aliyun_oss.inter.AliyunOssPutObjectCallBack;

/** AliyunOssPlugin */
public class AliyunOssPlugin implements FlutterPlugin, MethodCallHandler {

  private Context context;

  private MethodChannel channel;

  private Handler mainHandler = new Handler(Looper.getMainLooper());

  private static Map<String, AliyunOssClient> ossClients = new HashMap<>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "io.github/aliyun_oss");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull final MethodCall call, @NonNull final Result result) {
    if (call.method.equals("init")) {
      String endpoint = call.argument("endpoint");
      String stsServer = call.argument("stsServer");
      String clientKey = call.argument("clientKey");
      AliyunOssClient ossClient = new AliyunOssClient(context, new AliyunOssClientConfig(endpoint, stsServer),
              new AliyunOssClientConnectConfig(null, null, null, null));
      ossClients.put(clientKey, ossClient);
      result.success(true);
    } else if (call.method.equals("putObject")) {
      String bucketName = call.argument("bucketName");
      String objectName = call.argument("objectName");
      String filePath = call.argument("file");
      String clientKey = call.argument("clientKey");
      AliyunOssClient ossClient = ossClients.get(clientKey);
      String taskId = ossClient.putObject(bucketName, objectName, filePath, new AliyunOssPutObjectCallBack() {
        @Override
        public void onSuccess(String taskId, AliyunPutObjectResult aliyunPutObjectResult) {
          final Map<String, Object> res = new HashMap<>();
          res.put("url", aliyunPutObjectResult.getUrl());
          res.put("taskId", taskId);
          Runnable runnable = new Runnable() {
            @Override
            public void run() {
              channel.invokeMethod("onSuccess", res);
            }
          };
          mainHandler.post(runnable);
        }

        @Override
        public void onFailure(String taskId, AliyunPutObjectResult aliyunPutObjectResult) {
          final Map<String, Object> res = new HashMap<>();
          res.put("errorMessage", aliyunPutObjectResult.getMessage());
          res.put("taskId", taskId);
          Runnable runnable = new Runnable() {
            @Override
            public void run() {
              channel.invokeMethod("onFailure", res);
            }
          };
          mainHandler.post(runnable);
        }

        @Override
        public void onProgress(String taskId, long currentSize, long totalSize) {
          final Map<String, Object> res = new HashMap<>();
          res.put("currentSize", currentSize);
          res.put("totalSize", totalSize);
          res.put("taskId", taskId);
          /// fix: Methods marked with @UiThread must be executed on the main thread.
          Runnable runnable = new Runnable() {
            @Override
            public void run() {
              channel.invokeMethod("onProgress", res);
            }
          };
          mainHandler.post(runnable);
        }
      });
      result.success(taskId);
    } else if (call.method.equals("dispose")) {
      String clientKey = call.argument("clientKey");
      ossClients.remove(clientKey);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

}
