HybridBridge
================

This library use JavaScriptCore framework to bridge the gap between Javascript and Objective-C in hybrid app development.

It provides:
- Check whether the web resources updates, and download the latest version if needed.
- send message from javascript to native, and callback after native responsed. 
 
 The data flows: Javascript --> JavaScriptCore --> Native --> JavaScriptCore --> Javascript
- send message from native to javascript, and callback after Javascript responsed. 

  The data flows: Native --> JavaScriptCore --> JavaScript --> JavaScriptCore --> Native

With this library, you can communicate your native codes with web codes easily.


Hybrid Application
-----------------
Hybrid apps are part native apps, part web apps. Like native apps, they live in an app store and can take advantage of the many device features available. They rely on HTML being rendered in UIWebViews, so as to avoid publish new versions for some updates.


Installation
-------------------------
Cocoapod is really great. Here is an example of your podfile:

`
    pod 'HybridBridge'
`

Usage
--------------
Firstly, set your api base URL in AppDelegate:

```
#import "WebBridgeAPI.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  [WebBridgeAPI setAPIBaseURL:@"http://api.douban.com"];
  return YES;
}
```


Secondly, Inherite BridgeWebViewController for your custom controller

```
@interface MainViewController : BridgeWebViewController
```

And now you can communicate between js and objc.

- Send message from js to objc:

```
bridge.sendMessage(eventType, message, callbackFunction)

```
    
- Send message from objc to js:

```
[controller sendMessageToJS:message callback:^(id responseData) {
    NSLog(@"%@", responseData);
  }];
```

For more details, check the example project.

Other
-----
If you like it, please star this repo, thanks. Wating for your pull requests.
