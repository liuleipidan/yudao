//
//  YDIntegralHeaderView.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDIntegralHeaderView : UIView


/**
 设置显示内容

 @param allScore 累计积分
 @param usefulScore 可用积分
 */
- (void)setAllScore:(NSUInteger )allScore usefulScore:(NSUInteger)usefulScore;

@end
