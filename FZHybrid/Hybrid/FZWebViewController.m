//
//  FZWebViewController.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/18.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "FZWebViewController.h"
#import "FZWKWebViewController.h"
#import "FZUIWebViewController.h"

@interface FZWebViewController ()

@end

@implementation FZWebViewController

+ (instancetype)controllerWithType:(FZWebViewType)type url:(NSURL *)url
{
    return [self controllerWithType:type url:url params:nil];
}

+ (instancetype)controllerWithType:(FZWebViewType)type
                               url:(NSURL *)url
                            params:(id)params
{
   return [[self alloc] initWithType:type url:url params:params];
}

- (instancetype)initWithType:(FZWebViewType)type url:(NSURL *)url
{
    return [self initWithType:type url:url params:nil];
}

- (instancetype)initWithType:(FZWebViewType)type url:(NSURL *)url params:(id _Nullable)params
{
    FZWebViewController *webVC = nil;
    switch (type) {
        case FZWebViewTypeWK:
            webVC = [[FZWKWebViewController alloc] init];
            break;
            
        case FZWebViewTypeWeb:
            webVC = [[FZUIWebViewController alloc] init];
            break;
    }
    webVC.url = url;
    webVC.params = params;
    return webVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
