//
//  YDMomentViewDelegate.h
//  YuDao
//
//  Created by 汪杰 on 2017/11/9.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#ifndef YDMomentViewDelegate_h
#define YDMomentViewDelegate_h

//------------------  头部视图代理  ------------------
@class YDMoment,YDMomentVideoCell;
@protocol YDMomentHeaderViewDelegate <NSObject>

@optional
/**
 点击头像
 */
- (void)momentHedaerViewClickUserAvatar:(YDMoment *)moment;

/**
 点击添加好友
 */
- (void)momentHedaerViewClickRightButton:(UIButton *)btn moment:(YDMoment *)moment;

@end

//------------------  图片视图代理  ------------------
@protocol YDMomentImagesViewDelegate <NSObject>

@optional
/**
 点击图片
 */
- (void)momentImagesViewClickImageMoment:(YDMoment *)moment atIndex:(NSInteger )index;

/**
 点击视频播放按钮
 */
- (void)momentImagesViewClickVideoCell:(YDMomentVideoCell *)cell imageView:(UIImageView *)imageView;

@end

//------------------  底部视图代理  ------------------
@class YDMomentBottomView;
@protocol YDMomentBottomViewDelegate <NSObject>

@optional
/**
 点击左边按钮
 */
- (void)momentBottomViewClickLeftButton:(UIButton *)btn moment:(YDMoment *)moment;

/**
 点击中间按钮
 */
- (void)momentBottomViewClickCenterButton:(UIButton *)btn moment:(YDMoment *)moment;

/**
 点击右边按钮
 */
- (void)momentBottomViewClickRightButton:(UIButton *)btn moment:(YDMoment *)moment;

@end

//------------------  cell代理  ------------------
@protocol YDMomentCellDelegate <YDMomentHeaderViewDelegate,YDMomentImagesViewDelegate,YDMomentBottomViewDelegate>



@end

#endif /* YDMomentViewDelegate_h */
