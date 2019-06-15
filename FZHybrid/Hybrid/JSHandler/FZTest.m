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

@property (nonatomic, copy) CallBackBlock testBlock;

@end

@implementation FZTest

- (void)optionalInstanceTest:(id)params callBack:(void (^)(id))callBack
{
    NSLog(@"%@ : %@", NSStringFromSelector(_cmd), params);
    self.testBlock = callBack;
}

- (void)requiredInstanceTest:(id)params callBack:(void (^)(id))callBack
{
    NSLog(@"%@ : %@", NSStringFromSelector(_cmd), params);
    if (self.testBlock) {
        self.testBlock(@{@"job": @"扯淡", @"salary": @"50000", @"time": @"10"});
    } else if ([params isKindOfClass:[NSDictionary class]]) {
        CallBackBlock callBack = params[@"callBack"];
        if (callBack) {
            callBack(@{@"job": @"哔哔哔哔"});
        }
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

+ (void)requiredClassMethodTest:(id)params callBack:(void (^)(id))callBack {
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
