//
//  YDIgnoreView.h
//  YuDao
//
//  Created by 汪杰 on 2017/9/8.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 忽略视图样式

 - YDIgnoreViewTypeDefault: 默认为一行
 - YDIgnoreViewTypeTwoRow: 两行
 */
typedef NS_ENUM(NSInteger, YDIgnoreViewType) {
    YDIgnoreViewTypeDefault = 0,
    YDIgnoreViewTypeTwoRow,
};

@interface YDIgnoreView : UIView

/**
 弹出忽略视图

 @param rect 所点击的frame
 @param block 点击row回调，从1开始
 */
+ (void)showAtFrame:(CGRect )rect type:(YDIgnoreViewType)type clickedBlock:(void (^)(NSUInteger index))block;

@end
