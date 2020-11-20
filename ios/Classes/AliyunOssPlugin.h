#import <Flutter/Flutter.h>

#import"AliyunUploadManager.h"

#import "OSSPutClient.h"

typedef void (^AliyunResult)(NSDictionary *dictionary);

@interface AliyunOssPlugin : NSObject<FlutterPlugin>
@end



