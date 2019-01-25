//
//  FZLog.h
//  FZHybrid
//
//  Created by zzc483 on 2019/1/17.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZScriptMessageHandlerProtocol.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol FZLogProtocol <FZScriptMessageHandlerProtocol>

+ (void)log:(id)arguments;

@end

@protocol FZLogJSCoreProtocol <JSExport>

- (void)log:(id)arguments;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FZLog : NSObject <FZLogProtocol, FZLogJSCoreProtocol>

@end

NS_ASSUME_NONNULL_END
