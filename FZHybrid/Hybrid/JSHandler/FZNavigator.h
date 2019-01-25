//
//  FZNavigator.h
//  FZHybrid
//
//  Created by zzc483 on 2019/1/16.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZScriptMessageHandlerProtocol.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol FZNavigatorProtocol <FZScriptMessageHandlerProtocol>

- (void)push:(NSString *)path params:(id)params;

@end

@protocol FZNavigatorJSCoreProtocol <JSExport>

@property (nonatomic, weak) UIViewController *viewController;

- (void)push:(id)arguments;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FZNavigator : NSObject <FZNavigatorProtocol, FZNavigatorJSCoreProtocol>


@end

NS_ASSUME_NONNULL_END
