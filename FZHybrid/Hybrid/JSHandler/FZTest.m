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

- (void)optionalInstanceTest:(id)params
{
    NSLog(@"%@ : %@", NSStringFromSelector(_cmd), params);
    [self callWithArguments:params sel:_cmd completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"callWithArguments completion error: %@", error);
        } else {
            NSLog(@"callWithArguments completion response: %@", response);
        }
    }];
    
   
}

- (void)requiredInstanceTest:(id)params
{
    NSLog(@"%@ : %@", NSStringFromSelector(_cmd), params);
    
    [self callWithArguments:params sel:_cmd completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"callWithArguments completion error: %@", error);
        } else {
            NSLog(@"callWithArguments completion response: %@", response);
        }
    }];
}

+ (void)optionalClassTest
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

+ (void)requiredClassMethodTest
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
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
