//
//  YDUserFilesBottomView.h
//  YuDao
//
//  Created by 汪杰 on 17/1/20.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDUserInfoModel.h"

@class YDUserFilesBottomView;
@protocol YDUserFilesBottomViewDelegate <NSObject>

- (void)userFilesBottomView:(YDUserFilesBottomView *)bottomView didSelectedButton:(UIButton *)sender;

@end

@interface YDUserFilesBottomView : UIView

@property (nonatomic, weak  ) id<YDUserFilesBottomViewDelegate> delegate;

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

- (void)showInView:(UIView *)view
          userInfo:(YDUserInfoModel *)userInfo;

/**
 刷新界面显示

 @param userid 当前用户id
 @param fid 对方id
 @param enjoy 是否已经喜欢
 @param fStatus 与当前用户的关系状态
 */
- (void)updateViewWithCurrentUserID:(NSNumber *)userid
                           friendID:(NSNumber *)fid
                              enjoy:(NSNumber *)enjoy
                       friendStatus:(NSNumber *)fStatus;

@end
