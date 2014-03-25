//
//  JSCResponseDelegate.h
//  WebTest
//
//  Created by liaojinxing on 14-3-25.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSCResponseDelegate <NSObject>

- (id)responseForEventType:(NSString *)eventType message:(NSString *)message;

@end
