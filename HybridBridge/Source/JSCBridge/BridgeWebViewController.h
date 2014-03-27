//
//  BridgeWebViewController.h
//  WebTest
//
//  Created by liaojinxing on 14-3-25.
//  Copyright (c) 2014年 Douban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCResponseDelegate.h"


@interface BridgeWebViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, weak) id<JSCResponseDelegate> responseDelegate;

// 实现objc主动向js推送数据
// 与js端的receiveMessage配对使用：bridge.receiveMessage(key, callback)
- (void)sendMessageToJSForKey:(NSString *)key value:(id)message;

- (void)callHandler:(NSString *)handlerName
         parameters:(NSArray *)parameters
           callback:(void (^)(id responseData))callback;

@end