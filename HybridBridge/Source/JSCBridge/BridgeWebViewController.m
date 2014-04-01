//
//  BridgeWebViewController.m
//  WebTest
//
//  Created by liaojinxing on 14-3-25.
//  Copyright (c) 2014年 Douban. All rights reserved.
//

#import "BridgeWebViewController.h"
#import "JSCBridgeExport.h"
#import "UIWebView+JavaScriptContext.h"
#import "WebBridgeAPI.h"
#import "VersionControl.h"

@interface BridgeWebViewController ()<JSCBridgeExport, JSCWebViewDelegate>
{
  NSMutableDictionary* _jsHandlers;
}
@end

@implementation BridgeWebViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
  self.webView.delegate = self;
  [self.view addSubview:self.webView];
  _jsHandlers = [NSMutableDictionary dictionary];
}

- (void)dealloc
{
  _jsHandlers = nil;
}

- (void)webView:(UIWebView *)webView bridgeDidCreateJavaScriptContext:(JSContext *)ctx
{
  ctx[@"bridge"] = self;
  ctx[@"ready"] = @(YES);
}

// Javascript call objc
- (void)getJSONWithURL:(NSString *)URL
               options:(NSDictionary *)options
              callback:(JSValue *)callback
{
  AFHTTPRequestOperationManager *manager = [WebBridgeAPI sharedManager];
  [manager GET:URL
    parameters:options
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSString *json = [operation responseString];
         if (![callback isNull] && json) {
           [callback callWithArguments:@[json]];
         }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
       }];
}

- (void)sendDataWithEventType:(NSString *)eventType
                      message:(NSString *)message
                     callback:(JSValue *)callback
{
  id response = [self responseForEventType:eventType message:message];
  if (![callback isNull]) {
    [callback callWithArguments:@[response]];
  }
}

- (void)postWithEventType:(NSString *)eventType message:(NSString *)message
{
  JSContext *context = [_webView javaScriptContext];
  
  id response = [self responseForEventType:eventType message:message];
  NSString *responseID = [self responseIDForEventType:eventType];
  context[responseID] = response;
}

- (void)receiveWithEventType:(NSString *)eventType callback:(JSValue *)callback
{
  JSContext *context = [_webView javaScriptContext];
  NSString *responseID = [self responseIDForEventType:eventType];
  JSValue *response = context[responseID];
  if (![callback isNull] && ![response isUndefined]) {
    [callback callWithArguments:@[response]];
  }
}

- (NSString *)responseIDForEventType:(NSString *)eventType
{
  return eventType;
}

- (id)responseForEventType:(NSString *)eventType message:(NSString *)message
{
  if (self.responseDelegate) {
    return [self.responseDelegate responseForEventType:eventType message:message];
  }
  return @"response from objc to js";
}

// objc call javascript
- (void)registerHandler:(NSString *)handlerName handler:(JSValue *)handler
{
  [_jsHandlers setObject:handler forKey:handlerName];
}

- (void)callHandler:(NSString *)handlerName
         parameters:(NSArray *)parameters
           callback:(void (^)(id responseData))callback
{
  JSValue *handler = [_jsHandlers objectForKey:handlerName];
  if (nil == handler) {
    return;
  }
  JSValue *responseData = [handler callWithArguments:parameters];
  if (callback) {
    if ([responseData isUndefined] || [responseData isNull]) {
      responseData = nil;
    }
    callback(responseData);
  }
}

- (void)sendMessageToJSForKey:(NSString *)key value:(id)message
{
  JSContext *context = [_webView javaScriptContext];
  context[key] = message;
}

// advanced usage
- (NSString *)base64StringForImageURL:(NSString *)imageURL
                            imageType:(NSString *)imageType
{
  NSURL *URL = [NSURL URLWithString:imageURL];
  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:URL]];
  NSData *data = nil;
  NSString *prefix = nil;
  if ([imageType isEqualToString:@"png"]) {
    data = UIImagePNGRepresentation(image);
    prefix = @"data:image/png;base64,";
  } else if ([imageType isEqualToString:@"jpg"]) {
    data = UIImageJPEGRepresentation(image, 1.0);
    prefix = @"data:image/jpeg;base64,";
  }
  NSString *string = [data base64EncodedStringWithOptions:0];
  string = [NSString stringWithFormat:@"%@%@", prefix, string];
  return string;
}

@end

