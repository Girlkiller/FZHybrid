//
//  FZTest.h
//  FZHybrid
//
//  Created by feng qiu on 2019/1/15.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZScriptMessageHandlerProtocol.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol FZTestJSProtocol <FZScriptMessageHandlerProtocol>

@optional
- (void)optionalInstanceTest:(id)params callBack:(void(^)(id))callBack;
+ (void)optionalClassTest:(id)params callBack:(void(^)(id))callBack;

@required
- (void)requiredInstanceTest:(id)params callBack:(void(^)(id))callBack;
+ (void)requiredClassMethodTest:(id)params callBack:(void(^)(id))callBack;;

- (void)get:(id)params callBack:(void(^)(id response))callBack;

@end

@protocol FZTestJSCoreProtocol <JSExport>

@property (nonatomic, strong) NSMutableDictionary *params;

+ (instancetype)new;

- (NSString *)test;

JSExportAs(addParams, - (void)addParams:(NSDictionary *)params callBack:(JSValue *)callBack);


@end

NS_ASSUME_NONNULL_BEGIN

@interface FZTest : NSObject <FZTestJSProtocol, FZTestJSCoreProtocol>


@end

NS_ASSUME_NONNULL_END
