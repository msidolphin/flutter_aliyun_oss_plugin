package io.github.aliyun_oss;

import com.alibaba.sdk.android.oss.common.auth.OSSAuthCredentialsProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSCustomSignerCredentialProvider;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;

public class AliyunOssClientConfig {

    private String endpoint;

    private String accessKeyId;

    private String accessKeySecret;

    private String stsServer;

    public AliyunOssClientConfig(String endpoint, String accessKeyId, String accessKeySecret) {
        this.endpoint = endpoint;
        this.accessKeyId = accessKeyId;
        this.accessKeySecret = accessKeySecret;
    }

    public AliyunOssClientConfig(String endpoint, String accessKeyId, String accessKeySecret, String stsServer) {
        this.endpoint = endpoint;
        this.accessKeyId = accessKeyId;
        this.accessKeySecret = accessKeySecret;
        this.stsServer = stsServer;
    }

    public String getEndpoint() {
        return endpoint;
    }

    public String getAccessKeyId() {
        return accessKeyId;
    }

    public String getAccessKeySecret() {
        return accessKeySecret;
    }

    public String getStsServer() {
        return stsServer;
    }

    public OSSCredentialProvider getOSSCredentialProvider() {
        if (stsServer != null && !stsServer.trim().isEmpty()) {
            return new OSSAuthCredentialsProvider(stsServer);
        }
        return new OSSCustomSignerCredentialProvider() {
            @Override
            public String signContent(String content) {
            return OSSUtils.sign(accessKeyId, accessKeySecret, content);
            }
        };
    }

}
