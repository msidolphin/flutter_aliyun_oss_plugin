package io.github.aliyun_oss;

import com.alibaba.sdk.android.oss.ClientConfiguration;

import java.util.ArrayList;
import java.util.List;



public class AliyunOssClientConnectConfig {

    private static final int DEFAULT_MAX_RETRIES = 2;
    private static final int DEFAULT_SOCKET_TIMEOUT = 60 * 1000;
    private static final int DEFAULT_CONNECTION_TIMEOUT = 60 * 1000;
    private static final int DEFAULT_MAX_CONCURRENT_REQUEST = 5;

    private ClientConfiguration clientConfiguration;

    public AliyunOssClientConnectConfig(
            Integer connectionTimeout,
            Integer socketTimeout,
            Integer maxConcurrentRequest,
            Integer maxErrorRetry
    ) {
        clientConfiguration = new ClientConfiguration();
        clientConfiguration.setConnectionTimeout(connectionTimeout != null ? connectionTimeout : DEFAULT_CONNECTION_TIMEOUT); // 连接超时，默认15秒。
        clientConfiguration.setSocketTimeout(socketTimeout != null ? socketTimeout : DEFAULT_SOCKET_TIMEOUT); // socket超时，默认15秒。
        clientConfiguration.setMaxConcurrentRequest(maxConcurrentRequest != null ? maxConcurrentRequest : DEFAULT_MAX_CONCURRENT_REQUEST); // 最大并发请求数，默认5个。
        clientConfiguration.setMaxErrorRetry(maxErrorRetry != null ? maxErrorRetry : DEFAULT_MAX_RETRIES); // 失败后最大重试次数，默认2次。
    }

    public ClientConfiguration getClientConfiguration() {
        return clientConfiguration;
    }

}
