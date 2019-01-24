//
//  FZTest.m
//  FZHybrid
//
//  Created by feng qiu on 2019/1/15.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "FZTest.h"
#import "NSDictionary+JSONString.h"

@interface FZTest ()


@end

@implementation FZTest

- (void)optionalInstanceTest:(id)params callBack:(void (^)(id))callBack
{
    NSLog(@"%@ : %@", NSStringFromSelector(_cmd), params);
    if (callBack) {
        callBack(params);
    }
}

- (void)requiredInstanceTest:(id)params callBack:(void (^)(id))callBack
{
    NSLog(@"%@ : %@", NSStringFromSelector(_cmd), params);
    if (callBack) {
        callBack(params);
    }
}

+ (void)optionalClassTest:(id)params callBack:(void (^)(id))callBack
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
}

+ (void)requiredClassMethodTest
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)get:(id)params callBack:(void (^)(id))callBack
{
    if (callBack) {
        callBack(params);
    }
}

#pragma mark - FZTestJSCoreProtocol

- (NSString *)test
{
    return @"Hello World";
}

- (void)addParams:(NSDictionary *)params callBack:(JSValue *)callBack
{
    [self.params addEntriesFromDictionary:params];
    [callBack.context[@"setTimeout"] callWithArguments:@[callBack, @0, [self.params JSONString]]];
}

@end
