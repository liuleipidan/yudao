//
//  YDKeyboardsView.h
//  YuDao
//
//  Created by 汪杰 on 2018/3/29.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDEmojiKeyboardDelegate.h"

typedef NS_ENUM(NSInteger,YDKeyboardsViewStatus) {
    YDKeyboardsViewStatusInit,
    YDKeyboardsViewStatusSystem,
    YDKeyboardsViewStatusEmoji,
};

@class YDKeyboardsView;
@protocol YDKeyboardsViewDelegate<YDEmojiKeyboardDelegate>

@optional
- (void)keyboardsView:(YDKeyboardsView *)view statusDidChange:(YDKeyboardsViewStatus)status;

@end

@interface YDKeyboardsView : UIView

@property (nonatomic, weak  ) id<YDKeyboardsViewDelegate> delegate;

@property (nonatomic, assign) YDKeyboardsViewStatus status;

@property (nonatomic, assign) BOOL isShow;

- (void)showWillInView:(UIView *)view inputedView:(UIView *)inputedView;

- (void)dismiss;

@end
