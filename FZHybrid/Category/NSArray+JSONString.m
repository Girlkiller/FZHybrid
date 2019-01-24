//
//  NSArray+JSONString.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/22.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "NSArray+JSONString.h"

@implementation NSArray (JSONString)

- (NSString *)JSONString
{
    if (self == nil) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    
    if ([jsonData length] && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

@end
