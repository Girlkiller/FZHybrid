//
//  FZNotification.h
//  FZHybrid
//
//  Created by zzc483 on 2019/1/24.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZScriptMessageHandlerProtocol.h"

@protocol FZNotificationProtocol <FZScriptMessageHandlerProtocol>

- (void)registerNotification:(id)params callBack:(void(^)(id))callBack;

- (void)postNotification:(id)params;

- (void)removeNotification:(NSString *)name;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FZNotification : NSObject <FZNotificationProtocol>

@end

NS_ASSUME_NONNULL_END
