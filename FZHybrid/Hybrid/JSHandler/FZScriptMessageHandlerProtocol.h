//
//  FZScriptMessageProtocol.h
//  FZHybrid
//
//  Created by feng qiu on 2019/1/15.
//  Copyright © 2019年 qiufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FZScriptMessageHandlerProtocol

@optional

@property (nonatomic, strong) UIViewController *webViewController;

- (void)callWithArguments:(id)arguments
                      sel:(SEL)sel
        completionHandler:(void(^_Nullable)(id _Nullable response, NSError *_Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
