/**
 *主要作用于统一保存阿里云注册器
 */
#import <Flutter/Flutter.h>

#import "AliyunUploadManager.h"

@interface OSSPutClient : NSObject

@property(nonatomic, strong) FlutterMethodChannel *channel;

@property(nonatomic, strong) NSMutableDictionary *clients;

+(instancetype)shareInstall;
- (NSString *)invokeMethod:(NSString*)method arguments:(NSDictionary *)arguments;
@end
