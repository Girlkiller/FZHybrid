//
//  UIImage+Custom.h
//  ZuZuCheEasyRent
//
//  Created by zzc483 on 2019/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Custom)

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
