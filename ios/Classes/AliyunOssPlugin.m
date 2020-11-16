#import "AliyunOssPlugin.h"
#if __has_include(<aliyun_oss/aliyun_oss-Swift.h>)
#import <aliyun_oss/aliyun_oss-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "aliyun_oss-Swift.h"
#endif
#import <AliyunOSSiOS/OSSService.h>
@implementation AliyunOssPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [OSSPutClient shareInstall].channel = [FlutterMethodChannel methodChannelWithName:@"io.github/aliyun_oss" binaryMessenger:registrar.messenger];
    [[OSSPutClient shareInstall].channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        NSDictionary *arguments = (NSDictionary *)call.arguments;
        if ([call.method isEqualToString:@"init"]) {
            AliyunUploadManager *manager = [AliyunUploadManager managerWithArguments:call.arguments];
            [[OSSPutClient shareInstall].clients setObject:manager forKey:[arguments objectForKey:@"clientKey"]];
            result(@"true");
        }else if ([call.method isEqualToString:@"getPlatformVersion"]){
            //获取系统版本号
            result([NSString stringWithFormat:@"iOS%@",[UIDevice currentDevice].systemVersion]);
        }else if ([call.method isEqualToString:@"putObjectSync"] || [call.method isEqualToString:@"putObject"]){
           NSString *taskId = [[OSSPutClient shareInstall] invokeMethod:call.method arguments:arguments];
            result(taskId);
//            [AliyunUploadManager updateWithArguments:call.arguments channel:weakChannel];
        }
    }];
}
@end
@implementation OSSPutClient

+(instancetype)shareInstall{
    static OSSPutClient *client = nil;
    if (client ==nil) {
        client = [OSSPutClient new];
        client.clients = [NSMutableDictionary new];
    }
    return  client;
}
- (NSString *)invokeMethod:(NSString *)method arguments:(NSDictionary *)arguments{
    AliyunUploadManager *manager = [self.clients objectForKey:arguments[@"clientKey"]];
    return [manager updateWithArguments:arguments];
}
@end
@interface AliyunUploadManager()
@end

@implementation AliyunUploadManager
+(instancetype)managerWithArguments:(NSDictionary *)arguments{
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
-(NSString *)updateWithArguments:(NSDictionary *)arguments{
    
    NSString *taskId = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *objectName = arguments[@"objectName"];
    NSString *file = arguments[@"file"];
    NSString *bucketName = arguments[@"bucketName"];
//    NSString *clientKey = arguments[@"clientKey"];
    if ((NSNull *)objectName == [NSNull null] ||objectName == nil) {
        objectName = [[[[file componentsSeparatedByString:@"/"] lastObject] stringByReplacingOccurrencesOfString:@"image_picker_" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
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
                        @"message":@"上传成功"
                },
                @"taskId": taskId
            }];
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            [channel invokeMethod:@"onFailure" arguments:@{
                @"result": task.error.userInfo,
                @"taskId": taskId
            }];
        }
        return task;
    }];
    return  taskId;
}

@end
