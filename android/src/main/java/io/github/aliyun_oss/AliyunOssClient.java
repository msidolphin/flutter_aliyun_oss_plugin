package io.github.aliyun_oss;

import android.content.Context;

import com.alibaba.sdk.android.oss.ClientException;
import com.alibaba.sdk.android.oss.OSSClient;
import com.alibaba.sdk.android.oss.ServiceException;
import com.alibaba.sdk.android.oss.model.PutObjectRequest;
import com.alibaba.sdk.android.oss.model.PutObjectResult;

import java.util.UUID;

import io.flutter.Log;
import io.github.aliyun_oss.entity.AliyunPutObjectResult;

public class AliyunOssClient {

    private AliyunOssClientConfig clientConfig;

    private AliyunOssClientConnectConfig connectConfig;

    private OSSClient ossClient;

    public AliyunOssClient(Context context, AliyunOssClientConfig clientConfig, AliyunOssClientConnectConfig connectConfig) {
        this.clientConfig = clientConfig;
        this.connectConfig = connectConfig;
        ossClient = new OSSClient(context, "http://" + clientConfig.getEndpoint(), clientConfig.getOSSCredentialProvider(), connectConfig.getClientConfiguration());
    }

    public AliyunPutObjectResult putObjectSync(String bucketName, String objectName, String filePath) {
        if (objectName == null) objectName = UUID.randomUUID().toString().replace("-", "");
        PutObjectRequest put = new PutObjectRequest(bucketName, objectName, filePath);
        String url = "https://" + bucketName + "." + clientConfig.getEndpoint() + "/" + objectName;
        try {
            PutObjectResult putResult = ossClient.putObject(put);
            Log.d("PutObject", "UploadSuccess");
            Log.d("ETag", putResult.getETag());
            Log.d("RequestId", putResult.getRequestId());
            return new AliyunPutObjectResult(putResult, url);
        } catch (ClientException e) {
            Log.d("ClientException", e.getMessage());
            return new AliyunPutObjectResult(e);
        } catch (ServiceException e) {
            // 服务异常。
            Log.e("RequestId", e.getRequestId());
            Log.e("ErrorCode", e.getErrorCode());
            Log.e("HostId", e.getHostId());
            Log.e("RawMessage", e.getRawMessage());
            return new AliyunPutObjectResult(e);
        }
    }

}
