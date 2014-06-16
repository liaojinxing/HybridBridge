
HybridBridge
================

This library use JavaScriptCore framework to bridge the gap between Javascript and Objective-C in hybrid app development.

It provides:
- Template resource(html/js/css) management.
- send message from javascript to native, and callback after native responsed. 
 
 The data flows: Javascript --> JavaScriptCore --> Native --> JavaScriptCore --> Javascript

- Call javascript function in native, and callback after Javascript responsed. 

  The data flows: Native --> JavaScriptCore --> JavaScript --> JavaScriptCore --> Native

- Native send message to javascript, such as pushing notification.

With this library, you can communicate your native codes with web codes easily.


Hybrid Application
-----------------
Hybrid apps are part native apps, part web apps. Like native apps, they live in an app store and can take advantage of the many device features available. They rely on HTML being rendered in UIWebViews, so as to avoid publish new versions for some updates.


Installation
-------------------------
- Grab the source file into your project. 
- Or use cocoapods. Cocoapods is really great. Here is an example of your podfile:

```
pod 'HybridBridge'
```

JavaScript and Objc bridge
--------------
Inherite BridgeWebViewController for your custom controller

```
@interface MainViewController : BridgeWebViewController
```

And now you can communicate between js and objc.
### JavaScript driven 

There are two ways for JavaScript to drive to communication.

- Send message and callback

In your js code, you can use sendMessageAndCallback to send message from js to objc and callback after the send operation succeeds.
```
bridge.sendMessageAndCallback(eventType, message, callbackFunction)
```
    
- Post and receive messages

```
bridge.postMessage(eventType, message)   // post message to native
// other codes here
bridge.receiveMessage(eventType, callback)  //receive message from native
``` 

### Native driven
On the other hand, native can call JavaScript codes. After you register handler in JavaScript, you can call this handler in native side now.

JavaScript register handler:

```
bridge.registerHandler(handlerName, handler)
```

Native call handler:

```
[self callHandler:@"handler" parameters:@[] callback:^(id responseData) {
  // process with response data from js
}];
```

### Notification
Native push notification:
```
[self sendMessageToJSForKey:eventType value:messages];
```
JavaScript receive message:
```
bridge.receiveMessage(eventType, callback) 
```


Template Resource management
---------------------------
In hybrid app, in order to improve the performance, we always hold the template resources(html/js/css/img) locally. 

Firstly, set your api base URL, and create initial resources for the first time in AppDelegate:

```
#import "WebBridgeAPI.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  [WebBridgeAPI setAPIBaseURL:@"http://api.douban.com"];

  ResourceManager *manager = [ResourceManager sharedManager];
  [manager createInitialResource];
  return YES;
}
```

Check resource update and download if needed:
```
[WebBridgeAPI hasResourceUpdateWithLocalVersion:[manager currentVersion]
                                        success:^(VersionControl *versionControl) {
                                            if (versionControl.hasUpdate) {
                                              [manager downloadUpdatedResource:versionControl.versions];
                                            }
                                          } fail:NULL];
```


For more details, please check the example project.

