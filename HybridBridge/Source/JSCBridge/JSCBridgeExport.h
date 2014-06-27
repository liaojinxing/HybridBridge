//
//  JSCBridgeExport.h
//  WebTest
//
//  Created by liaojinxing on 14-3-25.
//  Copyright (c) 2014年 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSCBridgeExport <JSExport>

JSExportAs(getJSON,
           - (void)getJSONWithURL:(NSString *)URL
                          options:(NSDictionary *)options
                         callback:(JSValue *)callback);

JSExportAs(sendMessageAndCallback,
           - (void)sendDataWithEventType:(NSString *)eventType
                                 message:(NSString *)message
                                callback:(JSValue *)callback);
JSExportAs(postMessage,
           - (void)postWithEventType:(NSString *)eventType
                             message:(NSString *)message);
JSExportAs(receiveMessage,
           - (void)receiveWithEventType:(NSString *)eventType
                               callback:(JSValue *)callback);

JSExportAs(registerHandler,
           - (void)registerHandler:(NSString *)handlerName
                           handler:(JSValue *)handler);

JSExportAs(loadImage,
           - (void)loadImageWithURL:(NSString *)imageURL
           callback:(JSValue *)callback);

JSExportAs(console,
           - (void)console:(NSString *)message);

JSExportAs(pushController,
           - (BOOL)pushControllerWithHash:(NSString *)htmlHash
           controllerName:(NSString *)name);


@end