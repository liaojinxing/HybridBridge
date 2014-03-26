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

static NSString *kInitialResourceKey = @"InitialResource";
static NSString *kCurrentVersion = @"CurrentVersion";

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

- (NSString *)currentVersion
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *currentVersion = [defaults objectForKey:kCurrentVersion];
  return currentVersion?currentVersion:@"";
}

- (void)createInitialResource
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL initialed = [defaults boolForKey:kInitialResourceKey];
  if (initialed) {
    return;
  }
  
  NSString *path = [self resourceFilePath];
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
  }
  
  NSArray *fileTypes = [NSArray arrayWithObjects:@"html", @"js", @"css", nil];
  NSError *error;
  for (NSString *fileType in fileTypes) {
    NSString *fileTypePath = [NSString stringWithFormat:@"%@/web/%@", path, fileType];
    [[NSFileManager defaultManager] createDirectoryAtPath:fileTypePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error) {
      return;
    }
  }
  
  NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *files = [fileManager contentsOfDirectoryAtPath:resourcePath error:nil];
  for (NSString *file in files) {
    NSString *extention = [file pathExtension];
    if (![fileTypes containsObject:extention]) {
      continue;
    }
    NSString *fullPath = [resourcePath stringByAppendingPathComponent:file];
    NSString *fileTypePath = [NSString stringWithFormat:@"%@/web/%@/%@", path, extention, file];
    [fileManager copyItemAtPath:fullPath toPath:fileTypePath error:&error];
    if (error) {
      return;
    }
  }
  [NSThread sleepForTimeInterval:1];
  [defaults setBool:YES forKey:kInitialResourceKey];
}

- (void)downloadInitialResource
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL hasDownloaded = [defaults boolForKey:kInitialResourceKey];
  if (hasDownloaded) {
    return;
  }
  NSString *url = [NSString stringWithFormat:@"%@/web.zip", [WebBridgeAPI APIBaseURL]];
  void(^completeBlock)(void) = ^(void) {
    [defaults setBool:YES forKey:kInitialResourceKey];
  };
  [self downloadResourceWithURL:url completeBlock:completeBlock];
}

- (void)downloadUpdatedResource:(NSArray *)versionControls
{
  if (versionControls.count == 0) {
    return;
  }
  
  NSString *version = versionControls[0];
  NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:versionControls];
  [mutableArray removeObjectAtIndex:0];
  
  NSString *url = [NSString stringWithFormat:@"%@/%@.zip", [WebBridgeAPI APIBaseURL], version];
  __weak typeof(self) weakSelf = self;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  void(^completeBlock)(void) = ^(void) {
    [weakSelf downloadUpdatedResource:mutableArray];
    [defaults setObject:version forKey:kCurrentVersion];
  };
  
  [self downloadResourceWithURL:url completeBlock:completeBlock];
}

- (void)downloadResourceWithURL:(NSString *)url
{
  [self downloadResourceWithURL:url completeBlock:NULL];
}

- (void)downloadResourceWithURL:(NSString *)url completeBlock:(void (^)(void))completeBlock
{
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
                             NSString *destinationPath;
                             if ([[url lastPathComponent] isEqualToString:@"web.zip"]) {
                               destinationPath = path;
                             } else {
                               destinationPath = [NSString stringWithFormat:@"%@/web", path];
                             }
                             [SSZipArchive unzipFileAtPath:filePath toDestination:destinationPath];
                             [weakSelf clearZips];
                             if (completeBlock) {
                               completeBlock();
                             }
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
