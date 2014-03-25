//
//  UIWebView+JavaScriptContext.h
//  testJSWebView
//
//  Created by Nicholas Hodapp on 11/15/13.
//  Copyright (c) 2013 CoDeveloper, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSCWebViewDelegate <UIWebViewDelegate>

@optional

- (void)webView:(UIWebView *)webView bridgeDidCreateJavaScriptContext:(JSContext*) ctx;

@end


@interface UIWebView (JavaScriptContext)

@property (nonatomic, readonly) JSContext* javaScriptContext;

@end
