//
//  ResourceManager.h
//  WebTest
//
//  Created by liaojinxing on 14-3-19.
//  Copyright (c) 2014年 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManager : NSObject

@property (strong, nonatomic) NSString *resourceURL;

+ (instancetype)sharedManager;
- (NSString *)resourceFilePath;
- (void)clearZips;

- (void)downloadUpdatedResource:(NSArray *)updatedZipName;
- (void)downloadInitialResource;
- (void)downloadResourceWithURL:(NSString *)url;
- (void)createInitialResource;
- (NSString *)currentVersion;

@end
