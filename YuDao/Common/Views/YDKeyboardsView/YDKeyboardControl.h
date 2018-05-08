//
//  YDKeyboardControl.h
//  YuDao
//
//  Created by 汪杰 on 2018/4/2.
//  Copyright © 2018年 汪杰. All rights reserved.
//

#import <UIKit/UIKit.h>


static CGFloat const KeyboardControlToolHeight = 42.f;

@class YDKeyboardControl;
@protocol YDKeyboardControlDelegate <NSObject>

@optional
- (void)keyboardControl:(YDKeyboardControl *)control didDidChangeStatus:(YDKeyboardControlStatus )status;

@end

@interface YDKeyboardControl : UIView

@property (nonatomic, weak  ) id<YDKeyboardControlDelegate> delegate;

@property (nonatomic, assign) YDKeyboardControlStatus status;

- (void)dismissWithAnimated:(BOOL)animated;

@end
