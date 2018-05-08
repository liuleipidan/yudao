//
//  YDAvatarBrowser.h
//  YuDao
//
//  Created by 汪杰 on 2017/12/28.
//  Copyright © 2017年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDAvatarBrowser;
@protocol YDAvatarBrowserDelegate <NSObject>

@optional
- (void)avatarBrowser:(YDAvatarBrowser *)browser didClickedBottomButton:(UIButton *)button;

@end

@interface YDAvatarBrowser : UIView

@property (nonatomic, weak  ) id<YDAvatarBrowserDelegate> delegate;

//点击的图片
@property (nonatomic, strong) UIImageView *photoImageView;

//是否隐藏修改按钮，默认是NO
@property (nonatomic, assign) BOOL disableEditButton;

//是否关闭双击放大手势，默认是NO
@property (nonatomic, assign) BOOL disableDoubleTap;

//是否关闭长按手势，默认NO
@property (nonatomic, assign) BOOL disableLongpress;

//是否开启frame动画，默认是NO
@property (nonatomic, assign) BOOL frameAnimate;

/**
 弹出全屏的头像大图

 @param imageView 头像所在视图
 @param view 当前视图添加到的视图，为nil时去[UIApplication sharedApplication].keyWindow
 */
- (void)showByImageView:(UIImageView *)imageView inView:(UIView *)view;

- (void)dismiss;

@end
