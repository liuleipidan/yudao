//
//  YDCameraProgressView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/6.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDCameraProgressView : UIView

@property (nonatomic,copy) void (^timeOverBlock) (void);

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
