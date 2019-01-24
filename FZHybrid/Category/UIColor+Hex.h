//
//  UIColor+Hex.h
//  ZuZuCheEasyRent
//
//  Created by zzc483 on 2019/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hex;
+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
