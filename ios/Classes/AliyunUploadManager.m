
#import "AliyunUploadManager.h"

#import <AliyunOSSiOS/OSSService.h>

@implementation AliyunUploadManager

+(instancetype)managerWithArguments:(NSDictionary *) arguments{
    AliyunUploadManager *manager = [AliyunUploadManager new];
    manager.accessKeyId = arguments[@"accessKeyId"];
    manager.accessKeySecret = arguments[@"accessKeySecret"];
    manager.endpoint = arguments[@"endpoint"];
    manager.clientKey = arguments[@"clientKey"];
    manager.stsServer = arguments[@"stsServer"];
    id<OSSCredentialProvider> credential = [[OSSAuthCredentialProvider alloc] initWithAuthServerUrl:manager.stsServer];
    manager.client = [[OSSClient alloc] initWithEndpoint:manager.endpoint credentialProvider:credential];
    return  manager;
}

-(NSString *)updateWithArguments:(NSDictionary *) arguments{
    NSString *taskId = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *objectName = arguments[@"objectName"];
    NSString *file = arguments[@"file"];
    NSString *bucketName = arguments[@"bucketName"];
//    NSString *clientKey = arguments[@"clientKey"];
    if ((NSNull *)objectName == [NSNull null] ||objectName == nil) {
        objectName = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
    // 配置必填字段。
    put.bucketName = bucketName;
    put.objectKey = objectName;
    put.uploadingFileURL = [NSURL fileURLWithPath:file];
    put.contentType = @"application/octet-stream";
    put.contentMd5 = [OSSUtil base64Md5ForFilePath:file];
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 指定当前上传长度、当前已经上传总长度、待上传的总长度。
        [[OSSPutClient shareInstall].channel invokeMethod:@"onProgress" arguments:@{
            @"currentSize":@(totalByteSent),
            @"totalSize": @(totalBytesExpectedToSend),
            @"progress": @(totalByteSent/totalBytesExpectedToSend),
            @"taskId": taskId
        }];
    };
    OSSTask * putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        FlutterMethodChannel *channel = [OSSPutClient shareInstall].channel;
        if (!task.error) {
            NSLog(@"upload object success!");
            NSString *url = [NSString stringWithFormat:@"https://%@.%@/%@",bucketName,self.endpoint,objectName];
            OSSPutObjectResult *ossResult = task.result;
            NSDictionary *result = ossResult.httpResponseHeaderFields;
            [channel invokeMethod:@"onSuccess" arguments:@{
                @"result": @{
                        @"url": url,
                        @"requestId": ossResult.requestId,
                        @"statusCode": @(ossResult.httpResponseCode),
                        @"eTag": ossResult.eTag,
                        @"message":@"上传成功",
                        @"errorCode":@"-1",
                        @"isSuccess":@(true)
                },
                @"taskId": taskId
            }];
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            NSDictionary *dictionary = @{
                @"message":task.error.userInfo[@"ErrorMessage"],
                @"errorCode":@"-1",
                @"statusCode":@"0",
                @"isSuccess":@(false)
            };
            [channel invokeMethod:@"onFailure" arguments:@{
                @"result":dictionary,
                @"taskId": taskId
            }];
        }
        return task;
    }];
    return  taskId;
}
@end
