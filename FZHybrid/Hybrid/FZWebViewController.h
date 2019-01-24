//
//  FZWebViewController.h
//  FZHybrid
//
//  Created by zzc483 on 2019/1/18.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FZWebViewType) {
    FZWebViewTypeWK = 0,
    FZWebViewTypeWeb = 1
};

@interface FZWebViewController : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIView *webView;
@property (nonatomic, nullable, strong) id params;

+ (instancetype)controllerWithType:(FZWebViewType)type
                               url:(NSURL *)url;

+ (instancetype)controllerWithType:(FZWebViewType)type
                               url:(NSURL *)url
                            params:(id __nullable)params;

- (instancetype)initWithType:(FZWebViewType)type
                         url:(NSURL *)url;
- (instancetype)initWithType:(FZWebViewType)type
                         url:(NSURL *)url
                     params:(id __nullable)params;

@end

NS_ASSUME_NONNULL_END
