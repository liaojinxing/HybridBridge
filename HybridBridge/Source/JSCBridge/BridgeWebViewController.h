//
//  BridgeWebViewController.h
//  WebTest
//
//  Created by liaojinxing on 14-3-25.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSCResponseDelegate.h"


@interface BridgeWebViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, weak) id<JSCResponseDelegate> responseDelegate;

- (void)sendMessageToJS:(NSString *)message callback:(void (^)(id responseData))callback;

@end
