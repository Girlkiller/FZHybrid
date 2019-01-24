//
//  UIColor+Hex.m
//  ZuZuCheEasyRent
//
//  Created by zzc483 on 2019/1/9.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hex
{
    return [self colorWithHex:hex alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}

@end
