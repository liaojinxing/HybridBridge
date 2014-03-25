//
//  ViewController.m
//  WebTest
//
//  Created by Alvin on 14-2-7.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "MainViewController.h"
#import "ResourceManager.h"
#import "HelloViewController.h"
#import "WebViewJavascriptBridge.h"
#import "WebBridgeAPI.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface MainViewController ()<JSCResponseDelegate>

@property (strong, nonatomic)  UIBarButtonItem *switchButton;
//@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation MainViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadTamplate];
  
  self.responseDelegate = self;
}

/*
   - (void)viewWillAppear:(BOOL)animated
   {

   _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView
                                      webViewDelegate:self
                                              handler:^(id data, WVJBResponseCallback responseCallback) {
                                                NSLog(@"ObjC received message from JS: %@", data);
                                                responseCallback(@"Response for message from ObjC");
                                              }];

   [_bridge registerHandler:@"GetJsonFromObjc" handler:^(id data, WVJBResponseCallback responseCallback) {
    NSLog(@"testObjcCallback called: %@", data);
    [HybridAPI readMovieJsonSuccess:^(NSString *json) {
      responseCallback(json);
    } fail:NULL];

   }];
   }
 */

- (void)loadTamplate
{
  ResourceManager *manager = [ResourceManager sharedManager];

  NSString *filePath = [NSString stringWithFormat:@"%@/web/html/movie.html", [manager resourceFilePath]];
  NSURL *url = [NSURL fileURLWithPath:filePath isDirectory:NO];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [self.webView loadRequest:request];
}

- (BOOL)             webView:(UIWebView *)webView
  shouldStartLoadWithRequest:(NSURLRequest *)request
              navigationType:(UIWebViewNavigationType)navigationType
{
  NSString *urlString = request.URL.absoluteString;
  NSArray *components = [urlString componentsSeparatedByString:@"://"];
  if (components.count > 0 && [components[0] isEqualToString:@"doubanmovie"]) {
    HelloViewController *controller = [[HelloViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
  }
  return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}

- (NSString *)responseForEventType:(NSString *)eventType message:(NSString *)message
{
  return @"haha";
}

@end
