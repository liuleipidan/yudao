//
//  WJProgressView.h
//  YuDao
//
//  Created by 汪杰 on 2017/6/21.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJProgressView : UIView

@property (nonatomic,copy) void (^timeOverBlock) ();

/**
 最大拍摄时间
 */
@property (assign, nonatomic) NSInteger timeMax;

/**
 当前已经拍摄时间
 */
@property (nonatomic, assign) CGFloat currentTime;

- (void)clearProgress;

@end
