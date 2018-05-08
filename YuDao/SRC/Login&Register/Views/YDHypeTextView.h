//
//  YDHypeTextView.h
//  YuDao
//
//  Created by 汪杰 on 2017/7/12.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDHypeTextView : UIView

/**
 是否勾选，默认YES
 */
@property (nonatomic, assign) BOOL selected;

/**
 点击超链接
 */
@property (nonatomic,copy) void (^tapHypeTextBlock) (void);

/**
 勾选状态变化
 */
@property (nonatomic,copy) void (^checkStatusChangeBlock) (BOOL selected);

@end
