//
//  YDPayManager.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/19.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDPayManager : NSObject


/**
 调起支付宝支付
 */
+ (void)alipayWithPara:(NSDictionary *)para
               success:(void (^)(void))suceess
               failure:(void (^)(void))failure;

/**
 支付宝支付完成的回调

 @param url 回调网址
 */
+ (void)alipayCallback:(NSURL *)url;

@end
