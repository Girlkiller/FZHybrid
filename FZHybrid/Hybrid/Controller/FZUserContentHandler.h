//
//  FZUserContentHandler.h
//  FZHybrid
//
//  Created by zzc483 on 2019/1/16.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "FZScriptMessageHandlerProtocol.h"
#import "FZWKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CallBackBlock)(id);


@interface FZUserContentHandler : NSObject

@property (nonatomic, readonly, strong) WKUserContentController *userContentController;

- (instancetype)initWithUserContentController:(WKUserContentController *)userContentController;
- (void)injectJSHandlerWithWebVC:(FZWKWebViewController *)wkWebVC;
- (void)removeAllScriptMessageHandlers;

@end

NS_ASSUME_NONNULL_END
