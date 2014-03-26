//
//  HybridAPI.h
//  WebTest
//
//  Created by liaojinxing on 14-3-19.
//  Copyright (c) 2014年 Douban. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "VersionControl.h"

@interface WebBridgeAPI : NSObject

+ (AFHTTPRequestOperationManager *)sharedManager;

+ (void)hasResourceUpdateWithLocalVersion:(NSString *)version
                                  success:(void (^)(VersionControl *versionControl))successBlock
                                     fail:(void (^)(NSError *error))failed;


+ (void)readMovieJsonSuccess:(void (^)(NSString *json))success
                        fail:(void (^)(NSError *error))failed;

+ (void)setAPIBaseURL:(NSString *)URL;
+ (NSString *)APIBaseURL;

@end
