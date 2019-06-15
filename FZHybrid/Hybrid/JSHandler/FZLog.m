//
//  FZLog.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/17.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "FZLog.h"

@implementation FZLog

+ (void)log:(id)params
{
    NSLog(@"log: %@", params);
}

- (void)log:(id)arguments {
    NSLog(@"log: %@", arguments);
}

@end
