package io.github.aliyun_oss;

import android.content.Context;

import com.alibaba.sdk.android.oss.ClientException;
import com.alibaba.sdk.android.oss.OSSClient;
import com.alibaba.sdk.android.oss.ServiceException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.internal.OSSAsyncTask;
import com.alibaba.sdk.android.oss.model.PutObjectRequest;
import com.alibaba.sdk.android.oss.model.PutObjectResult;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import io.flutter.Log;
import io.github.aliyun_oss.entity.AliyunPutObjectResult;
import io.github.aliyun_oss.inter.AliyunOssPutObjectCallBack;

public class AliyunOssClient {

    private AliyunOssClientConfig clientConfig;

    private AliyunOssClientConnectConfig connectConfig;

    private OSSClient ossClient;

    /// <requestId, task>
    private Map<String, OSSAsyncTask> tasks = new HashMap<>();

    public AliyunOssClient(Context context, AliyunOssClientConfig clientConfig, AliyunOssClientConnectConfig connectConfig) {
        this.clientConfig = clientConfig;
        this.connectConfig = connectConfig;
        ossClient = new OSSClient(context, "http://" + clientConfig.getEndpoint(), clientConfig.getOSSCredentialProvider(), connectConfig.getClientConfiguration());
    }

    @Deprecated
    public AliyunPutObjectResult putObjectSync(String bucketName, String objectName, String filePath) {
        objectName = getObjectName(objectName);
        PutObjectRequest put = new PutObjectRequest(bucketName, objectName, filePath);
        String url = "https://" + bucketName + "." + clientConfig.getEndpoint() + "/" + objectName;
        try {
            PutObjectResult putResult = ossClient.putObject(put);
            return new AliyunPutObjectResult(putResult, url);
        } catch (ClientException e) {
            return new AliyunPutObjectResult(e);
        } catch (ServiceException e) {
            return new AliyunPutObjectResult(e);
        }
    }

    public String putObject(String bucketName, String objectName, String filePath, final AliyunOssPutObjectCallBack callBack) {
        objectName = getObjectName(objectName);
        PutObjectRequest put = new PutObjectRequest(bucketName, objectName, filePath);
        final String url = "https://" + bucketName + "." + clientConfig.getEndpoint() + "/" + objectName;
        final String taskId = UUID.randomUUID().toString().replace("-", "");
        // 异步上传时可以设置进度回调。
        put.setProgressCallback(new OSSProgressCallback<PutObjectRequest>() {
            @Override
            public void onProgress(PutObjectRequest request, long currentSize, long totalSize) {
                callBack.onProgress(taskId, currentSize, totalSize);
            }
        });
        OSSAsyncTask task = ossClient.asyncPutObject(put, new OSSCompletedCallback<PutObjectRequest, PutObjectResult>() {
            @Override
            public void onSuccess(PutObjectRequest request, PutObjectResult result) {
                AliyunPutObjectResult aliyunPutObjectResult = new AliyunPutObjectResult(result, url);
                callBack.onSuccess(taskId, aliyunPutObjectResult);
            }

            @Override
            public void onFailure(PutObjectRequest request, ClientException clientExcepion, ServiceException serviceException) {
                AliyunPutObjectResult aliyunPutObjectResult = null;
                // 请求异常。
                if (clientExcepion != null) {
                    aliyunPutObjectResult = new AliyunPutObjectResult(clientExcepion);
                }
                if (serviceException != null) {
                    aliyunPutObjectResult = new AliyunPutObjectResult(serviceException);
                }
                callBack.onFailure(taskId, aliyunPutObjectResult);
                tasks.remove(taskId);
            }
        });
        tasks.put(taskId, task);
        return taskId;
    }

    private String getObjectName(String objectName) {
        if (objectName == null) objectName = UUID.randomUUID().toString().replace("-", "");
        return  objectName;
    }

}
