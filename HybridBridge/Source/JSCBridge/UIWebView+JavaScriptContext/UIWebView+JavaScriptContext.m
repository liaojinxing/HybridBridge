//
//  UIWebView+JavaScriptContext.m
//
//  Created by Nicholas Hodapp on 11/15/13.
//  Copyright (c) 2013 CoDeveloper, LLC. All rights reserved.
//

#import "UIWebView+JavaScriptContext.h"

#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>

static const char kTSJavaScriptContext[] = "BridgeJavaScriptContext";

static NSHashTable *g_webViews = nil;

@interface UIWebView (JavaScriptContextPrivate)
- (void)bridgeDidCreateJavaScriptContext:(JSContext *)javaScriptContext;
@end


@protocol JSCWebFrame <NSObject>
- (id)parentFrame;
@end

@implementation NSObject (JavaScriptContext)

- (void)webView:(id)unused didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id<JSCWebFrame>)frame
{
  NSParameterAssert([frame respondsToSelector:@selector(parentFrame)]);

  // only interested in root-level frames
  if ([frame respondsToSelector:@selector(parentFrame) ] && [frame parentFrame] != nil) return;

  void (^ notifyDidCreateJavaScriptContext)() = ^{
    for (UIWebView *webView in g_webViews) {
      NSString *cookie = [NSString stringWithFormat:@"ts_jscWebView_%lud", (unsigned long)webView.hash ];

      [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var %@ = '%@'", cookie, cookie ] ];

      if ([ctx[cookie].toString isEqualToString:cookie]) {
        [webView bridgeDidCreateJavaScriptContext:ctx];
        return;
      }
    }
  };

  if ([NSThread isMainThread]) {
    notifyDidCreateJavaScriptContext();
  } else {
    dispatch_async(dispatch_get_main_queue(), notifyDidCreateJavaScriptContext);
  }
}

@end


@implementation UIWebView (JavaScriptContext)

+ (id)allocWithZone:(struct _NSZone *)zone
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
                  g_webViews = [NSHashTable weakObjectsHashTable];
                });

  NSAssert([NSThread isMainThread], @"should be in main thread");

  id webView = [super allocWithZone:zone];

  [g_webViews addObject:webView];

  return webView;
}

- (void)bridgeDidCreateJavaScriptContext:(JSContext *)javaScriptContext
{
  [self willChangeValueForKey:@"bridgeJavaScriptContext"];

  objc_setAssociatedObject(self, kTSJavaScriptContext, javaScriptContext, OBJC_ASSOCIATION_RETAIN);

  [self didChangeValueForKey:@"bridgeJavaScriptContext"];

  if ([self.delegate respondsToSelector:@selector(webView:bridgeDidCreateJavaScriptContext:)]) {
    id<JSCWebViewDelegate> delegate = (id<JSCWebViewDelegate>)self.delegate;
    [delegate webView:self bridgeDidCreateJavaScriptContext:javaScriptContext];
  }
}

- (JSContext *)javaScriptContext
{
  JSContext *javaScriptContext = objc_getAssociatedObject(self, kTSJavaScriptContext);

  return javaScriptContext;
}

@end