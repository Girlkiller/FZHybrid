//
//  NSDictionary+JSONString.m
//  FZHybrid
//
//  Created by feng qiu on 2019/1/17.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "NSDictionary+JSONString.h"

@implementation NSDictionary (JSONString)

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
