package io.github.aliyun_oss.inter;

import io.github.aliyun_oss.entity.AliyunPutObjectResult;

public interface AliyunOssPutObjectCallBack {

    void onSuccess(String taskId, AliyunPutObjectResult result);

    void onFailure(String taskId, AliyunPutObjectResult result);

    void onProgress(String taskId, long currentSize, long totalSize);

}
