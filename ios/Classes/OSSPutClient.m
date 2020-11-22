#import "OSSPutClient.h"

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
