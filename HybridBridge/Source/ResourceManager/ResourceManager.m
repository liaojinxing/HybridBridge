//
//  ResourceManager.m
//  WebTest
//
//  Created by liaojinxing on 14-3-19.
//  Copyright (c) 2014年 Douban. All rights reserved.
//

#import "ResourceManager.h"
#import "SSZipArchive.h"
#import "WebBridgeAPI.h"

@implementation ResourceManager

#pragma mark -  singleton methods
+ (instancetype)sharedManager
{
  static id instance = nil;
  static dispatch_once_t onceToken = 0L;
  dispatch_once(&onceToken, ^{
                  instance = [[ResourceManager alloc] init];
                });
  return instance;
}

- (NSString *)resourceURL
{
  if (!_resourceURL) {
    return [NSString stringWithFormat:@"%@/web.zip", [WebBridgeAPI APIBaseURL]];
  }
  return _resourceURL;
}

- (NSString *)resourceFilePath
{
  NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentdirectory = [path objectAtIndex:0];
  return [documentdirectory stringByAppendingPathComponent:@"ResourceBundle"];
}

- (void)downloadUpdatedResource
{
  NSString *url = self.resourceURL;
  NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                          timeoutInterval:10.0];

  __weak typeof(self) weakSelf = self;
  [NSURLConnection sendAsynchronousRequest:theRequest
                                     queue:[[NSOperationQueue alloc] init]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
     NSLog(@"%@", response);
     NSString *path = [self resourceFilePath];
     NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, [url lastPathComponent]];
     if (![[NSFileManager defaultManager] fileExistsAtPath:path])
       [[NSFileManager defaultManager] createDirectoryAtPath:path
                                 withIntermediateDirectories:NO
                                                  attributes:nil
                                                       error:nil];
     if ([data writeToFile:filePath atomically:YES]) {
       NSLog(@"Downloaded File");
       NSString *destinationPath = [NSString stringWithFormat:@"%@/web", path];
       [SSZipArchive unzipFileAtPath:filePath toDestination:destinationPath];
       [weakSelf clearZips];
     } else {
       NSLog(@"failed");
     }
   }];
}

- (void)clearZips
{
  NSString *path = [self resourceFilePath];
  NSError *error = nil;
  NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
  for (NSString *fileName in directoryContents) {
    NSArray *postfix = [[fileName lastPathComponent] componentsSeparatedByString:@"."];
    if (postfix.count > 1 && [postfix[1] isEqualToString:@"zip"]) {
      NSString *fullName = [path stringByAppendingPathComponent:fileName];
      if ([[NSFileManager defaultManager] removeItemAtPath:fullName error:NULL]  == YES) {
        NSLog(@"Remove zip successful");
      } else {
        NSLog(@"Remove zip failed");
      }
    }
  }
}

@end
