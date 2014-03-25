//
//  VersionControl.h
//  WebTest
//
//  Created by liaojinxing on 14-3-19.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "JSONModel.h"

@interface VersionControl : JSONModel

@property (strong, nonatomic) NSString *version;
@property (assign, nonatomic) BOOL hasUpdate;

@end
