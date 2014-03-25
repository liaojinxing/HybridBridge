//
//  ResourceManager.h
//  WebTest
//
//  Created by liaojinxing on 14-3-19.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManager : NSObject

@property (strong, nonatomic) NSString *resourceURL;

+ (instancetype)sharedManager;
- (void)downloadUpdatedResource;
- (NSString *)resourceFilePath;
- (void)clearZips;

@end
