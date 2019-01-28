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

- (instancetype)initWithURL:(NSURL *)url
{
    return [self initWithType:FZWebViewTypeWK url:url params:nil];
}

- (instancetype)initWithURL:(NSURL *)url params:(id)params
{
    return [self initWithType:FZWebViewTypeWK url:url params:params];
}

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
    switch (type) {
        case FZWebViewTypeWK:
            return [[FZWKWebViewController alloc] initWithURL:url params:params];
            break;
        case FZWebViewTypeWeb:
            return [[FZUIWebViewController alloc] initWithURL:url params:params];
            break;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
