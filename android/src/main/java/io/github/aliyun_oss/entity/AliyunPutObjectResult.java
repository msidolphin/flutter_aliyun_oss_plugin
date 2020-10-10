package io.github.aliyun_oss.entity;

import com.alibaba.sdk.android.oss.ClientException;
import com.alibaba.sdk.android.oss.ServiceException;
import com.alibaba.sdk.android.oss.model.PutObjectResult;

import java.util.HashMap;
import java.util.Map;

public class AliyunPutObjectResult extends PutObjectResult {

    private String url;

    private Boolean isSuccess;

    private String errorCode;

    private String hostId;

    private String rawMessage;

    private String partNumber;

    private String partEtag;

    private String message;

    public AliyunPutObjectResult() {}

    public AliyunPutObjectResult(PutObjectResult putObjectResult, String url) {
        this.setETag(putObjectResult.getETag());
        this.setRequestId(putObjectResult.getRequestId());
        this.setStatusCode(putObjectResult.getStatusCode());
        this.setClientCRC(putObjectResult.getClientCRC());
        this.setResponseHeader(putObjectResult.getResponseHeader());
        this.setServerCRC(putObjectResult.getServerCRC());
        this.setServerCallbackReturnBody(putObjectResult.getServerCallbackReturnBody());
        this.setUrl(url);
        this.setMessage("ok");
        this.setIsSuccess(true);
    }

    public AliyunPutObjectResult(ServiceException e) {
        this.setRequestId(e.getRequestId());
        this.setStatusCode(e.getStatusCode());
        this.setErrorCode(e.getErrorCode());
        this.setHostId(e.getHostId());
        this.setRawMessage(e.getRawMessage());
        this.setPartNumber(e.getPartNumber());
        this.setPartEtag(e.getPartEtag());
        this.setIsSuccess(false);
    }

    public AliyunPutObjectResult(ClientException e) {
        this.setMessage(e.getMessage());
        this.setIsSuccess(false);
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Boolean getIsSuccess() {
        return isSuccess;
    }

    public void setIsSuccess(Boolean success) {
        isSuccess = success;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getHostId() {
        return hostId;
    }

    public void setHostId(String hostId) {
        this.hostId = hostId;
    }

    public String getRawMessage() {
        return rawMessage;
    }

    public void setRawMessage(String rawMessage) {
        this.rawMessage = rawMessage;
    }

    public String getPartNumber() {
        return partNumber;
    }

    public void setPartNumber(String partNumber) {
        this.partNumber = partNumber;
    }

    public String getPartEtag() {
        return partEtag;
    }

    public void setPartEtag(String partEtag) {
        this.partEtag = partEtag;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Map<String, Object> toMap() {
        Map<String, Object> map = new HashMap<>();
        map.put("url", url);
        map.put("isSuccess", isSuccess);
        map.put("errorCode", errorCode);
        map.put("statusCode", getStatusCode());
        map.put("message", message);
        map.put("eTag", getETag());
        map.put("requestId", getRequestId());
        return map;
    }

}
