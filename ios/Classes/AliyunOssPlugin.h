#import <Flutter/Flutter.h>
#import <AliyunOSSiOS/OSSService.h>


typedef void (^AliyunResult)(NSDictionary *dictionary);

@interface AliyunOssPlugin : NSObject<FlutterPlugin>
@end

@interface AliyunUploadManager : NSObject
@property (nonatomic, strong) NSString *accessKeyId;
@property (nonatomic, strong) NSString *accessKeySecret;
@property (nonatomic, strong) NSString *endpoint;
@property (nonatomic, strong) NSString *clientKey;
@property (nonatomic, strong) NSString *stsServer;
@property (nonatomic, strong) OSSClient *client;

/*
 *flutter 调用阿里云init方法时调用，主要用于储存相关配置信息
 */
+(instancetype)managerWithArguments:(NSDictionary *)arguments;
/*
 *flutter 调用阿里云上传方法时调用
 */
-(NSString *)updateWithArguments:(NSDictionary *)arguments;
@end
/**
 *主要作用于统一保存阿里云注册器
 */
@interface OSSPutClient : NSObject

@property(nonatomic, strong) FlutterMethodChannel *channel;

@property(nonatomic, strong) NSMutableDictionary *clients;

+(instancetype)shareInstall;
- (NSString *)invokeMethod:(NSString*)method arguments:(NSDictionary *)arguments;
@end
