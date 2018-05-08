//
//  YDAdviseHeaderView.h
//  YuDao
//
//  Created by 汪杰 on 2018/1/30.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDAdviseHeaderView;
@protocol YDAdviseHeaderViewDelegate<NSObject>

- (void)adviseHeaderView:(YDAdviseHeaderView *)headerView didClickedCommitButton:(UIButton *)button;

@end

@interface YDAdviseHeaderView : UIView

@property (nonatomic, weak  ) id<YDAdviseHeaderViewDelegate> delegate;

@property (nonatomic, copy ) NSString *text;

@end
