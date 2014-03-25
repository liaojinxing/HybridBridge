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

JSExportAs(getJson,
           - (void)getJsonWithURL:(NSString *)URL
                         callback:(JSValue *)callback);

JSExportAs(sendMessage,
           - (void)sendDataWithEventType:(NSString *)eventType
                                 message:(NSString *)message
                                callback:(JSValue *)callback);
JSExportAs(postMessage,
           - (void)postWithEventType:(NSString *)eventType
                             message:(NSString *)message);
JSExportAs(receiveMessage,
           - (void)receiveWithEventType:(NSString *)eventType
                               callback:(JSValue *)callback);

@end
