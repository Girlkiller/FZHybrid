//
//  NSObject+AssociateObject.h
//  FZHybrid
//
//  Created by zzc483 on 2019/1/17.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AssociateObject)

@property (nonatomic, strong) id associatedObject;
@property (nonatomic, weak) id associatedWeakObject;

@end

NS_ASSUME_NONNULL_END
