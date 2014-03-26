//
//  VersionControl.h
//  WebTest
//
//  Created by liaojinxing on 14-3-19.
//  Copyright (c) 2014年 Douban. All rights reserved.
//

#import "JSONModel.h"

@interface VersionControl : JSONModel

@property (strong, nonatomic) NSArray *versions;
@property (assign, nonatomic) BOOL hasUpdate;

@end
