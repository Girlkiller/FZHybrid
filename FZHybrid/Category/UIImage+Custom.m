//
//  UIImage+Custom.m
//  ZuZuCheEasyRent
//
//  Created by zzc483 on 2019/1/9.
//

#import "UIImage+Custom.h"

@implementation UIImage (Custom)

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color
{
    return  [self imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (cornerRadius < 0) {
        cornerRadius = 0;
    } else if (cornerRadius > MIN(width, height)) {
        cornerRadius = MIN(width, height)/2.;
    }
    UIImage *image = [self imageWithColor:color size:size];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [path addClip];
    [image drawInRect:rect];
    UIImage * theimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theimage;
}

@end
