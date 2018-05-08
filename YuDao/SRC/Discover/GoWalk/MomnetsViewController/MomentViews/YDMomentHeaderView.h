//
//  YDMomentHeaderView.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDMomentViewDelegate.h"
#import "YDMoment.h"

@interface YDMomentHeaderView : UIView

@property (nonatomic, weak  ) id<YDMomentHeaderViewDelegate> delegate;

/**
 设置动态的用户信息
 */
- (void)setMomentUserInfo:(YDMoment *)moment;

@end
