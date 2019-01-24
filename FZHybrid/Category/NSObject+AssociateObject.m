//
//  NSObject+AssociateObject.m
//  FZHybrid
//
//  Created by zzc483 on 2019/1/17.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import "NSObject+AssociateObject.h"

@implementation NSObject (AssociateObject)

@dynamic associatedObject;
@dynamic associatedWeakObject;

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self, _cmd, associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject
{
    return objc_getAssociatedObject(self, @selector(setAssociatedWeakObject:));
}

- (void)setAssociatedWeakObject:(id)associatedObject
{
    objc_setAssociatedObject(self, _cmd, associatedObject, OBJC_ASSOCIATION_ASSIGN);
}

- (id)associatedWeakObject
{
    return objc_getAssociatedObject(self, @selector(setAssociatedWeakObject:));
}


@end
