//
//  FZUserContentHandler.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/16.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "FZUserContentHandler.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import "NSObject+AssociateObject.h"
#import "NSDictionary+JSONString.h"
#import "NSArray+JSONString.h"

@interface FZUserContentHandler () <WKScriptMessageHandler>

@property (nonatomic, readwrite, strong) WKUserContentController *userContentController;
@property (nonatomic, weak) FZWKWebViewController *wkWebVC;
@property (nonatomic, strong) NSMutableDictionary *methodsCache;

@end

@implementation FZUserContentHandler

- (void)dealloc
{
    [_userContentController removeAllUserScripts];
}

- (instancetype)initWithUserContentController:(WKUserContentController *)userContentController
{
    if (self = [super init]) {
        _userContentController = userContentController;
        _methodsCache = [NSMutableDictionary dictionary];
        NSString *jsBridgePath = [[NSBundle mainBundle] pathForResource:@"www/libs/native/JSNative" ofType:@"js"];
        NSString *jsScript = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:jsBridgePath] encoding:NSUTF8StringEncoding];
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsScript injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        [_userContentController addUserScript:userScript];
    }
    return self;
}

- (void)injectJSHandlerWithWebVC:(FZWKWebViewController *)wkWebVC
{
    _wkWebVC = wkWebVC;
    [self injectAllMessageHandler];
}

- (void)removeAllScriptMessageHandlers
{
    [self.methodsCache enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.userContentController removeScriptMessageHandlerForName:key];
    }];
}

#pragma mark - JSHandler viewController

- (void)setWebViewController:(UIViewController *)webViewController
{
    objc_setAssociatedObject(self, _cmd, webViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)webViewController
{
    return objc_getAssociatedObject(self, @selector(setWebViewController:));
}


#pragma mark - private

- (void)injectAllMessageHandler
{
    CFAbsoluteTime beginTime = CFAbsoluteTimeGetCurrent();
    unsigned int classCount;
    const char **classes;
    Dl_info info;
    
    dladdr(&_mh_execute_header, &info);
    classes = objc_copyClassNamesForImage(info.dli_fname, &classCount);
    for (unsigned index = 0; index < classCount; index++) {
        NSString *className = [NSString stringWithCString:classes[index] encoding:NSUTF8StringEncoding];
        Class class = NSClassFromString(className);
        if (class_conformsToProtocol(class, @protocol(FZScriptMessageHandlerProtocol))) {
            unsigned int protocolCount = 0;
            Protocol *__unsafe_unretained *protocols = class_copyProtocolList(class, &protocolCount);
            id instance = [[class alloc] init];
            //set the real call back object
            [instance setAssociatedWeakObject:self];
            //add call back method
            SEL callBackSel = @selector(callWithArguments:sel:completionHandler:);
            Method callBackMethod = class_getInstanceMethod([self class], callBackSel);
            class_addMethod(class, callBackSel, class_getMethodImplementation([self class], callBackSel), method_getTypeEncoding(callBackMethod));
            //add viewController setter
            SEL vcSetterSel = @selector(setWebViewController:);
            Method vcSetterMethod = class_getInstanceMethod([self class], vcSetterSel);
            BOOL addedSetter = class_addMethod(class, vcSetterSel, class_getMethodImplementation([self class], vcSetterSel), method_getTypeEncoding(vcSetterMethod));
            //set current web viewController
            if (addedSetter) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [instance performSelector:vcSetterSel withObject:self.wkWebVC];
#pragma clang diagnostic pop
            }
            //add viewController getter
            SEL vcGetterSel = @selector(webViewController);
            Method vcGetterMethod = class_getInstanceMethod([self class], vcGetterSel);
            class_addMethod(class, vcGetterSel, class_getMethodImplementation([self class], vcGetterSel), method_getTypeEncoding(vcGetterMethod));
            NSLog(@"****************%@********************", className);
            for(int i = 0; i < protocolCount; i++) {
                Protocol *protocol = protocols[i];
                if (protocol_conformsToProtocol(protocol, @protocol(FZScriptMessageHandlerProtocol))) {
                    [self injectMethodsWithProtocol:protocol class:class instance:instance isRequired:YES isInstance:YES];
                    [self injectMethodsWithProtocol:protocol class:class instance:instance isRequired:YES isInstance:NO];
                    [self injectMethodsWithProtocol:protocol class:class instance:instance isRequired:NO isInstance:NO];
                    [self injectMethodsWithProtocol:protocol class:class instance:instance isRequired:NO isInstance:YES];
                    break;
                }
            }
            
            free(protocols);
        }

    }
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"方法注入完毕，共耗时：%f", endTime - beginTime);
}

- (void)injectMethodsWithProtocol:(Protocol *)protocol
                        class:(Class)class
                         instance:(id)instance
                       isRequired:(BOOL)isRequired
                       isInstance:(BOOL)isInstance
{
    unsigned int methodCount = 0;
    struct objc_method_description *method_descs = protocol_copyMethodDescriptionList(protocol, isRequired, isInstance, &methodCount);
    for (int methodIndex = 0; methodIndex < methodCount; methodIndex++) {
        struct objc_method_description method_desc = method_descs[methodIndex];
        SEL sel = method_desc.name;
        NSString *methodName = NSStringFromSelector(sel);
        NSString *jsMethodName = methodName;
        if ([methodName containsString:@":"]) {
            NSArray *methodNameStrs = [methodName componentsSeparatedByString:@":"];
            jsMethodName = methodNameStrs.firstObject;
        }
        if (jsMethodName.length) {
            NSAssert(self.methodsCache[jsMethodName] == nil, @"%@不可重复注入", jsMethodName);
            [self.userContentController addScriptMessageHandler:self name:jsMethodName];
            [self.methodsCache setObject:[@{@"class": class,
                                           @"instance": instance,
                                           @"method": methodName} mutableCopy] forKey:jsMethodName];
            NSLog(@"\n[--oc %@ | %@ js--]", methodName, jsMethodName);
        }
    }
    
    free(method_descs);
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self handlerScriptMessage:message];
}

- (void)handlerScriptMessage:(WKScriptMessage *)message
{
    NSString *jsMethodName = message.name;
    NSMutableDictionary *methodInfo = self.methodsCache[jsMethodName];
    if (methodInfo) {
        Class class = methodInfo[@"class"];
        id instance = methodInfo[@"instance"];
        NSString *methodName = methodInfo[@"method"];
        SEL sel = NSSelectorFromString(methodName);
        
        /*! The body of the message.
         Allowed types are NSNumber, NSString, NSDate, NSArray,
         NSDictionary, and NSNull.
         */
        id body = message.body;
        //only NSDictionary contains a callBack
        if ([body isKindOfClass:[NSDictionary class]]) {
            body = [body mutableCopy];
            [message.body enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]] && [obj hasPrefix:@"function"]) {
                    methodInfo[@"callBack"] = obj;
                    [body removeObjectForKey:key];
                    *stop = YES;
                }
            }];
        } else if ([body isKindOfClass:[NSString class]] && [(NSString *)body hasPrefix:@"function"]) {
            methodInfo[@"callBack"] = body;
        } else if ([body isKindOfClass:[NSNull class]]) {
            body = nil;
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (instance && [instance respondsToSelector:sel]) {
            [instance performSelector:sel withObject:body];
        } else if (class && [class respondsToSelector:sel]) {
            [class performSelector:sel withObject:body];
        }
#pragma clang diagnostic pop
    }

}

#pragma mark - FZMessageCallBackProtocol

- (void)callWithArguments:(id)arguments
                      sel:(SEL)sel
        completionHandler:(void(^_Nullable)(id _Nullable response, NSError *_Nullable error))completionHandler
{
    //real call back object
    FZUserContentHandler *trueSelf = self.associatedWeakObject;
    if (trueSelf == nil) {
        return;
    }
    NSString *methodName = NSStringFromSelector(sel);
    if ([methodName containsString:@":"]) {
        NSArray *methodNameStrs = [methodName componentsSeparatedByString:@":"];
        methodName = methodNameStrs.firstObject;
    }
    if (!methodName.length) {
        NSLog(@"callWithArguments方法不存在");
        return;
    }
    NSDictionary *methodInfo = trueSelf.methodsCache[methodName];
    if (methodInfo && [methodInfo isKindOfClass:[NSDictionary class]]) {
        NSString *callBack = methodInfo[@"callBack"];
        if (callBack) {
            NSString *callBackFormat = [callBack stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([callBackFormat hasPrefix:@"function"]) {
                [trueSelf callAnonymousFunction:callBackFormat params:arguments completionHandler:completionHandler];
            }
        }
    }
    
}

#pragma mark - call anonymous function

- (void)callAnonymousFunction:(NSString *)callBack
                       params:(id)params
            completionHandler:(void(^_Nullable)(id _Nullable response, NSError *_Nullable error))completionHandler
{
    id paramsFormat = params;
    if ([params isKindOfClass:[NSArray class]] || [params isKindOfClass:[NSDictionary class]]) {
        paramsFormat = [params JSONString];
    } else if ([params isKindOfClass:[NSDate class]]) {
        paramsFormat = [NSNumber numberWithDouble:[params timeIntervalSince1970]];
    }
    
    NSString *functionFormat = [NSString stringWithFormat:@"var _jsCallBack_ = new Function(\"return \" + %@)();\
                                var callBackFunc=function(param){_jsCallBack_.apply(this, [param]);};var nativeParams=%@; callBackFunc(nativeParams);", callBack, paramsFormat];
    [(WKWebView *)self.wkWebVC.webView evaluateJavaScript:functionFormat completionHandler:completionHandler];
}



@end
