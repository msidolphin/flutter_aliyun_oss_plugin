package io.github.aliyun_oss;

import com.alibaba.sdk.android.oss.common.auth.OSSAuthCredentialsProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;

public class AliyunOssClientConfig {

    private String endpoint;

    private String stsServer;

    public AliyunOssClientConfig(String endpoint, String stsServer) {
        this.endpoint = endpoint;
        this.stsServer = stsServer;
    }

    public String getEndpoint() {
        return endpoint;
    }

    public OSSCredentialProvider getOSSCredentialProvider() {
        return new OSSAuthCredentialsProvider(stsServer);
    }

}
