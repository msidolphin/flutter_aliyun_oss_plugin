#import "AliyunOssPlugin.h"
#if __has_include(<aliyun_oss/aliyun_oss-Swift.h>)
#import <aliyun_oss/aliyun_oss-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "aliyun_oss-Swift.h"
#endif

@implementation AliyunOssPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAliyunOssPlugin registerWithRegistrar:registrar];
}
@end
