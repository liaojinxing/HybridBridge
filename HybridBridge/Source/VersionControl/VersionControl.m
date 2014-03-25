//
//  VersionControl.m
//  WebTest
//
//  Created by liaojinxing on 14-3-19.
//  Copyright (c) 2014年 Douban. All rights reserved.
//

#import "VersionControl.h"

@implementation VersionControl

+ (JSONKeyMapper *)keyMapper
{
  return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
