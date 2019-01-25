//
//  FZNavigator.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/16.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "FZNavigator.h"
#import <objc/runtime.h>
#import "FZWebViewController.h"

@implementation FZNavigator

- (void)push:(NSString *)path params:(id)params
{
    NSURL *url;
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"www/html/%@", path] ofType:@"html"]];
    } else {
        url = [NSURL URLWithString:path];
    }
    FZWebViewController *webVC;
    UIViewController *currentVC;
    if ([self respondsToSelector:@selector(webViewController)]) {
        currentVC = self.webViewController;
        webVC = [[FZWebViewController alloc] initWithType:FZWebViewTypeWK url:url params:params];
    } else if ([self respondsToSelector:@selector(viewController)]) {
        currentVC = self.viewController;
        webVC = [[FZWebViewController alloc] initWithType:FZWebViewTypeWeb url:url params:params];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (currentVC.navigationController) {
            [currentVC.navigationController pushViewController:webVC animated:YES];
        }
    });
    
}

#pragma mark - FZNavigatorJSCoreProtocol

- (void)setViewController:(UIViewController *)viewController
{
    objc_setAssociatedObject(self, _cmd, viewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)viewController
{
    return objc_getAssociatedObject(self, @selector(setViewController:));
}


@end
