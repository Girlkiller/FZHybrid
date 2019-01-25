//
//  FZNotification.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/24.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "FZNotification.h"

@interface FZNotification ()

@property (nonatomic, strong) NSMutableDictionary *notifcationCache;

@end

@implementation FZNotification

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init]) {
        _notifcationCache = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)registerNotification:(NSString *)notificationName callBack:(void (^)(id))callBack
{
    NSAssert(notificationName.length, @"通知名不可为空");
    NSMutableArray *callBacks = self.notifcationCache[notificationName];
    if (callBack) {
        if (callBacks) {
            [callBacks addObject:callBack];
        } else {
            callBacks = [NSMutableArray arrayWithCapacity:0];
            [callBacks addObject:callBack];
            self.notifcationCache[notificationName] = callBacks;
        }
    }
    
    NSLog(@"注册通知-- %@: %@", notificationName, callBacks);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:notificationName object:nil];
}

- (void)postNotification:(NSString *)notificationName params:(id)params
{
    NSAssert(notificationName.length, @"通知名不可为空");
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:params userInfo:params];
}

- (void)removeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)receivedNotification:(NSNotification *)notification
{
    NSString *notificationName = notification.name;
    NSMutableArray *callBacks = self.notifcationCache[notificationName];
    NSDictionary *userInfo = notification.userInfo ?: notification.object;
    for (id obj in callBacks) {
        ((void(^)(id))obj)(userInfo);
    }
}


@end
