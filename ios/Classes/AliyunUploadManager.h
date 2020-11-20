
#import <Foundation/Foundation.h>

#import <AliyunOSSiOS/OSSService.h>

#import "OSSPutClient.h"

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
