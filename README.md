
HybridBridge
================

This library provides a basic framework for iOS hybrid development.

It provides:
- Template resource(html/js/css) management.
- Bridge for coding with JS and Objc, using JavaScriptCore.Framework.
    - send message from JavaScript to native, and callback after native responsed. 
    
    The data flows: Javascript --> JavaScriptCore --> Native --> JavaScriptCore --> Javascript

    - Call JavaScript function in native, and callback after Javascript responsed. 
    
    The data flows: Native --> JavaScriptCore --> JavaScript --> JavaScriptCore --> Native
    
    - Native send message to JavaScript, such as pushing notification.

With this library, you can communicate your native codes with web codes easily.


Hybrid Application
-----------------
Hybrid apps are part native apps, part web apps. Like native apps, they live in an app store and can take advantage of the many device features available. They rely on HTML being rendered in UIWebViews, so as to avoid publish new versions for some updates. More details in this [Blog]. 


Installation
-------------------------
- Grab the source file into your project. 
- Or use cocoapods. CocoaPods is really great. Here is an example of your podfile:

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
#### JavaScript driven 

There are two ways for JavaScript to drive to communication.

- Send message and callback

In your js code, you can use sendMessageAndCallback to send message from js to objc and callback after the send operation succeeds.
```
bridge.sendMessageAndCallback(eventType, message, callbackFunction)
```
    
#### Native driven
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

#### Notification
Native push notification:
```
[self sendMessageToJSForKey:eventType value:messages];
```
JavaScript receive message:
```
bridge.receiveMessage(eventType, callback) 
```

#### Some Common Usage
- Push ViewController. 
```
bridge.pushController(url, name)    
```
The name is used to route controller in navite end.

- Get JSON:
```
bridge.getJSON(url, options, callback)
```

Template Resource management
---------------------------
In hybrid app, in order to improve the performance, we always hold the template resources(html/js/css/img) locally. 

Firstly, create initial resources for the first time in AppDelegate:

```
#import "WebBridgeAPI.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.

  ResourceManager *manager = [ResourceManager sharedManager];
  [manager createInitialResource];
  return YES;
}
```

Check resource update and download if needed:

For more details, please check the example project.

Subscription
-------
欢迎关注[简书]，关注微信公众号(iOSers)，订阅高质量原创技术文章：

<img src="http://upload-images.jianshu.io/upload_images/1859836-2f44998e2341e34d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" alt="公众号" width="300px" hspace="10"/>

[Blog]:http://liaojinxing.github.io/%E6%B7%B7%E5%90%88%E5%BC%80%E5%8F%91%E5%AE%9E%E8%B7%B5/
[简书]:http://www.jianshu.com/users/25481f0294aa/latest_articles

