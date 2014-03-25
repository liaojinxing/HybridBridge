//
//  HybridAPI.m
//  WebTest
//
//  Created by liaojinxing on 14-3-19.
//  Copyright (c) 2014年 Douban. All rights reserved.
//

#import "WebBridgeAPI.h"

@implementation WebBridgeAPI

static NSString *baseURL = nil;

+ (AFHTTPRequestOperationManager *)sharedManager
{
  static id instance = nil;
  static dispatch_once_t onceToken = 0L;
  dispatch_once(&onceToken, ^{
                  instance = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
                });
  return instance;
}

+ (void)setAPIBaseURL:(NSString *)URL
{
  baseURL = URL;
}

+ (void)hasResourceUpdateSuccess:(void (^)(VersionControl *versionControl))successBlock
                            fail:(void (^)(NSError *error))failed
{
  AFHTTPRequestOperationManager *manager = [WebBridgeAPI sharedManager];
  [manager GET:@"hasUpdate"
    parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"%@", operation.responseString);
     if (successBlock) {
       NSError *error = nil;
       VersionControl *versionControl = [[VersionControl alloc] initWithString:operation.responseString error:&error];
       successBlock(versionControl);
     }
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"%@", error);
     if (failed) {
       failed(error);
     }
   }];
}

+ (void)readMovieJsonSuccess:(void (^)(NSString *json))success
                        fail:(void (^)(NSError *error))failed
{
  AFHTTPRequestOperationManager *manager = [WebBridgeAPI sharedManager];

  NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:@"movie" relativeToURL:manager.baseURL] absoluteString] parameters:nil error:nil];
  [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];

  NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
  if (cachedResponse) {
    NSString *cachedString = [[NSString alloc] initWithData:[cachedResponse data] encoding:NSUTF8StringEncoding];
    success(cachedString);
    return;
  }

  AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         if (success) {
                                           success(operation.responseString);
                                         }
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                         if (failed) {
                                           failed(error);
                                         }
                                       }];
  [manager.operationQueue addOperation:operation];
}

@end
