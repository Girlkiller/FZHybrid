//
//  FZWKWebViewController.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/15.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "FZWKWebViewController.h"
#import "UIColor+Hex.h"
#import "FZUserContentHandler.h"
#import "NSDictionary+JSONString.h"
#import "NSArray+JSONString.h"

@interface FZWKWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, weak) FZUserContentHandler *contentHandler;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) WKWebView *wkWebView;

@end

static NSString *JS_NATIVE_PARAMS = @"JS_NATIVE_PARAMS";

@implementation FZWKWebViewController

#pragma mark 移除观察者
- (void)dealloc
{
    [self.contentHandler removeAllScriptMessageHandlers];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}

- (instancetype)initWithURL:(NSURL *)url
{
    return [self initWithURL:url params:nil];
}

- (instancetype)initWithURL:(NSURL *)url params:(id)params
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

- (UIView *)webView
{
    return _wkWebView;
}

- (void)createWebView
{
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    FZUserContentHandler *contentHandler = [[FZUserContentHandler alloc] initWithUserContentController:userContentController];
    [contentHandler injectJSHandlerWithWebVC:self];
    self.contentHandler = contentHandler;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.preferences = [[WKPreferences alloc] init];
    configuration.allowsInlineMediaPlayback = YES;
    configuration.selectionGranularity = WKSelectionGranularityDynamic;
    configuration.userContentController = userContentController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    webView.UIDelegate = self;
    webView.allowsBackForwardNavigationGestures = YES;
    webView.navigationDelegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    self.wkWebView = webView;
    
    //TODO:kvo监听，获得页面title和加载进度值
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark 加载进度条
- (UIProgressView *)progress
{
    if (_progress == nil)
    {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_MAX_Y, SCREEN_WIDTH, 2)];
        _progress.tintColor = [UIColor colorWithHex:0x32CD32];
        _progress.backgroundColor = [UIColor colorWithHex:0xd9d9d9];
        [self.view addSubview:_progress];
    }
    return _progress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.webView)
        {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.wkWebView.estimatedProgress animated:YES];
            if(self.wkWebView.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:0.5f
                                      delay:0.3f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView)
        {
            self.navigationItem.title = self.wkWebView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}




#pragma mark - WKUIDelegate

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return nil;
}

/**
 webView中弹出警告框时调用, 只能有一个按钮
 
 @param webView webView
 @param message 提示信息
 @param frame 可用于区分哪个窗口调用的
 @param completionHandler 警告框消失的时候调用, 回调给JS
 */

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"alert: %@", message);
    completionHandler();
}

/** 对应js的confirm方法
 webView中弹出选择框时调用, 两个按钮
 
 @param webView webView description
 @param message 提示信息
 @param frame 可用于区分哪个窗口调用的
 @param completionHandler 确认框消失的时候调用, 回调给JS, 参数为选择结果: YES or NO
 */

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    completionHandler(YES);
}

/** 对应js的prompt方法
 webView中弹出输入框时调用, 两个按钮 和 一个输入框
 
 @param webView webView description
 @param prompt 提示信息
 @param defaultText 默认提示文本
 @param frame 可用于区分哪个窗口调用的
 @param completionHandler 输入框消失的时候调用, 回调给JS, 参数为输入的内容
 */

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    completionHandler(@"yes");
}

- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0))
{
    return YES;
}

- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0))
{
    return nil;
}


- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0))
{
    
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([navigationAction.request.URL.absoluteString isEqualToString:self.url.absoluteString]) {
         decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        FZWKWebViewController *webVC = [[FZWKWebViewController alloc] initWithURL:navigationAction.request.URL params:nil];
        [self.navigationController pushViewController:webVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    id paramsFormat = self.params;
    if ([self.params isKindOfClass:[NSArray class]] || [self.params isKindOfClass:[NSDictionary class]]) {
        paramsFormat = [self.params JSONString];
    } else if ([self.params isKindOfClass:[NSDate class]]) {
        paramsFormat = [NSNumber numberWithDouble:[self.params timeIntervalSince1970]];
    }
    [webView evaluateJavaScript:[NSString stringWithFormat:@"var JS_NATIVE_PARAMS = %@;", paramsFormat] completionHandler:^(id response, NSError * error) {
        
    }];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
{
   
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    
}

@end
