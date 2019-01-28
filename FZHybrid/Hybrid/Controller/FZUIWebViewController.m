//
//  FZUIWebViewController.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/18.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "FZUIWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import "FZScriptMessageHandlerProtocol.h"

@interface NSObject (WebView)

@end

static NSString *CLASS_NAME_PREFIX = @"JSNative_";
static NSString *INSTANCE_NAME_SUFFIX = @"_Instance";
static NSString *CONTEXT_FLAG = @"CONTEXT_FLAG";
static NSString *IOS_VERSION = @"IOS_VERSION";
static NSString *VIEWCONTROLLER = @"VIEWCONTROLLER";

@implementation NSObject (WebView)

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)context forFrame:(id)frame
{
    NSString *jsBridgePath = [[NSBundle mainBundle] pathForResource:@"www/libs/native/JSNative" ofType:@"js"];
    NSString *jsScript = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:jsBridgePath] encoding:NSUTF8StringEncoding];
    [context evaluateScript:jsScript];
//    NSString *requireJSPath = [[NSBundle mainBundle] pathForResource:@"www/libs/require/require" ofType:@"js"];
//    NSString *requireJSScript = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:requireJSPath] encoding:NSUTF8StringEncoding];
//    [context evaluateScript:requireJSScript];
    [self injectClassInConext:context];
}

#pragma mark - private

- (void)injectClassInConext:(JSContext *)context
{
    if (!context) {
        return;
    }
    CFAbsoluteTime beginTime = CFAbsoluteTimeGetCurrent();
    unsigned int classCount;
    const char **classes;
    Dl_info info;
    
    dladdr(&_mh_execute_header, &info);
    classes = objc_copyClassNamesForImage(info.dli_fname, &classCount);
    for (unsigned classIndex = 0; classIndex < classCount; ++classIndex) {
        NSString *className = [NSString stringWithCString:classes[classIndex] encoding:NSUTF8StringEncoding];
        Class class = NSClassFromString(className);
        if (class_conformsToProtocol(class, @protocol(JSExport))) {
            NSLog(@"className = %@", className);
            NSString *jsObjectName = [NSString stringWithFormat:@"%@%@", CLASS_NAME_PREFIX, className];
            NSString *instanceName = [jsObjectName stringByAppendingString:INSTANCE_NAME_SUFFIX];
            context[instanceName] = [[class alloc] init];
            context[jsObjectName] = class;
        }
    }
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"类注入完毕，共耗时：%f", endTime - beginTime);
}

@end

@interface FZUIWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *uiWebView;

@end

static NSString *JS_NATIVE_PARAMS = @"JS_NATIVE_PARAMS";

@implementation FZUIWebViewController

- (void)dealloc
{
    [self.uiWebView stopLoading];
    self.uiWebView.delegate = nil;
}

- (instancetype)initURL:(NSURL *)url
{
    return [self initURL:url params:nil];
}

- (instancetype)initURL:(NSURL *)url params:(id)params
{
    if (self = [super init]) {
        self.url = url;
        self.params = params;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createWebView];
}

- (void)createWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = self.view.backgroundColor;
    webView.delegate = self;
    webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.view addSubview:webView];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [webView loadRequest:request];
    self.uiWebView = webView;
}

- (UIView *)webView
{
    return _uiWebView;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self.url.absoluteString);
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[IOS_VERSION] = [UIDevice currentDevice].systemVersion;
    context[CONTEXT_FLAG] = [NSString stringWithFormat:@"%p", context];
    context[JS_NATIVE_PARAMS] = self.params;
    context[VIEWCONTROLLER] = self;
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
    };
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self.title.length == 0) {
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        NSString *title = [[context evaluateScript:@"document.title"] toString];
        if (title.length > 0) {
            self.title = title;
        }
    }
    
    [webView stringByEvaluatingJavaScriptFromString:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"WebView failed: %@", [error localizedDescription]);
}

@end
